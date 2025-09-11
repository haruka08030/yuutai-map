import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stock/domain/entities/user_benefit.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _tzReady = false;

  Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings();
    const init = InitializationSettings(android: android, iOS: iOS);
    await _plugin.initialize(init);

    // TZDB を初期化し、ローカルを東京固定にする
    _ensureTz();

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  void _ensureTz() {
    if (_tzReady) return;
    try {
      tz_data.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Tokyo'));
      _tzReady = true;
    } catch (_) {
      // 失敗しても後続で再試行する
      _tzReady = false;
    }
  }

  int _baseId(String uuid) {
    final hex = uuid.replaceAll('-', '');
    final slice = hex.substring(0, 8);
    return int.parse(slice, radix: 16) & 0x7FFFFFFF; // 31bit
  }

  int _bitForDay(int d) {
    switch (d) {
      case 0:
        return 1 << 0;
      case 1:
        return 1 << 1;
      case 7:
        return 1 << 2;
      case 30:
        return 1 << 3;
      default:
        return 0;
    }
  }

  Iterable<int> _decodeReminderDays(int? v) {
    // null => 通知なし
    if (v == null) return const [];

    // 新エンコード: custom*1000 + mask(下位4bit)
    if (v >= 1000) {
      final custom = v ~/ 1000;
      final mask = v % 1000;
      final result = <int>{custom};
      for (final d in const [30, 7, 1, 0]) {
        if ((mask & _bitForDay(d)) != 0) {
          result.add(d);
        }
      }
      return result;
    }

    // 旧エンコード: >15 は単一カスタム
    if (v > 15 && v != 30 && v != 7 && v != 1 && v != 0) {
      return [v]; // custom single day
    }

    // 旧エンコード: 単一プリセット
    if (v == 0 || v == 1 || v == 7 || v == 30) {
      return [v];
    }

    // 旧エンコード: ビットマスク
    final result = <int>[];
    for (final d in const [30, 7, 1, 0]) {
      if ((v & _bitForDay(d)) != 0) {
        result.add(d);
      }
    }
    return result;
  }

  Future<void> reschedulePresetReminders(UserBenefit b) async {
    _ensureTz();
    await cancelAllFor(b.id);
    if (b.isUsed || b.expireOn == null) return;

    final base = _baseId(b.id);
    final expire = b.expireOn!;
    final anchors = _decodeReminderDays(
      b.notifyBeforeDays,
    ).map<(int daysBefore, int idSuffix)>((d) => (d, d));

    final tokyo = tz.getLocation('Asia/Tokyo');
    final nowTz = tz.TZDateTime.now(tokyo);
    // 固定で朝9時（JST）に通知
    const hour = 9;
    for (final a in anchors) {
      final scheduled = tz.TZDateTime(
        tokyo,
        expire.year,
        expire.month,
        expire.day,
        hour,
      );
      final when = scheduled.subtract(Duration(days: a.$1));
      if (when.isBefore(nowTz)) {
        continue;
      }

      await _plugin.zonedSchedule(
        base + a.$2,
        '優待の期限が近づいています',
        '${b.title}：${a.$1 == 0 ? '本日が有効期限' : '${a.$1}日前'}',
        when,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'yuutai',
            '優待リマインダー',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  Future<void> cancelAllFor(String uuid) async {
    final base = _baseId(uuid);
    // 0..365 の範囲で関連IDを一括キャンセル（プレセット＋カスタム想定）
    for (int s = 0; s <= 365; s++) {
      await _plugin.cancel(base + s);
    }
  }
}
