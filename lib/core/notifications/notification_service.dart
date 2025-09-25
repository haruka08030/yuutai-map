import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stock/domain/entities/user_benefit.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();
  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings();
    const init = InitializationSettings(android: android, iOS: iOS);
    await _plugin.initialize(init);

    // TZDB を初期化し、ローカルを東京固定にする
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Tokyo'));

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

  int _baseId(String uuid) {
    final hex = uuid.replaceAll('-', '');
    final slice = hex.substring(0, 8);
    return int.parse(slice, radix: 16) & 0x7FFFFFFF; // 31bit
  }

  Future<void> reschedulePresetReminders(UserBenefit b) async {
    await cancelAllFor(b.id);
    if (b.isUsed || b.expireOn == null) return;

    final base = _baseId(b.id);
    final expire = b.expireOn!;
    final selected = b.notifyBeforeDays;
    final anchors = selected == null
        ? <(int daysBefore, int idSuffix)>[(30, 30), (7, 7), (1, 1), (0, 0)]
        : <(int daysBefore, int idSuffix)>[(selected, selected.clamp(0, 30))];

    final tokyo = tz.getLocation('Asia/Tokyo');
    final nowTz = tz.TZDateTime.now(tokyo);
    for (final a in anchors) {
      final scheduled = tz.TZDateTime(
        tokyo,
        expire.year,
        expire.month,
        expire.day,
        (b.notifyAtHour ?? 9).clamp(0, 23),
      );
      final when = scheduled.subtract(Duration(days: a.$1));
      if (when.isBefore(nowTz)) continue;

      await _plugin.zonedSchedule(
        base + a.$2,
        '優待の期限が近づいています',
        '${b.title}:${a.$1 == 0 ? '本日が有効期限' : '${a.$1}日前'}',
        when,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'yuutai',
            'Yuutai Reminders',
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
    final ids = [base + 30, base + 7, base + 1, base + 0];
    for (final id in ids) {
      await _plugin.cancel(id);
    }
  }
}
