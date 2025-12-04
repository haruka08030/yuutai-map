import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stock/domain/entities/benefit_status.dart';
import 'package:flutter_stock/domain/entities/users_yuutai.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService instance = NotificationService._();
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const DarwinInitializationSettings iOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings settings = InitializationSettings(
      android: android,
      iOS: iOS,
    );
    await _plugin.initialize(settings);
  }

  Future<void> cancelAllFor(String id) async {
    final pending = await _plugin.pendingNotificationRequests();
    for (final p in pending) {
      if (p.payload == id) {
        await _plugin.cancel(p.id);
      }
    }
  }

  Future<void> reschedulePresetReminders(UsersYuutai b) async {
    if (b.id == null) return;
    final idStr = b.id.toString();
    await cancelAllFor(idStr);

    if (b.status == BenefitStatus.used) {
      return;
    }

    final expireOn = b.expiryDate;
    if (expireOn == null) {
      return;
    }

    final now = DateTime.now();
    if (expireOn.isBefore(now)) {
      return;
    }

    if (!b.alertEnabled) return;

    final days = b.notifyDaysBefore;
    if (days == null || days <= 0) {
      return;
    }
    
    final notifyAtHour = 9;

    final scheduledAt = expireOn.subtract(Duration(days: days));
    if (scheduledAt.isBefore(now)) {
      return;
    }

    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'benefit-reminder-$days',
        '期限リマインダー ($days日前)',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
      scheduledAt.copyWith(hour: notifyAtHour, minute: 0, second: 0),
      tz.local,
    );

    await _plugin.zonedSchedule(
      b.id.hashCode, // Use a single ID per benefit
      '優待の期限が近づいています',
      '「${b.companyName}」の期限が$days日後です。',
      scheduledDate,
      notificationDetails,
      payload: idStr,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
