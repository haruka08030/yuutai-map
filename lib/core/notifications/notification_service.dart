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

    if (b.status == BenefitStatus.used || !b.alertEnabled) {
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

    final daysList = b.notifyDaysBefore;
    if (daysList == null || daysList.isEmpty) {
      return;
    }
    
    final notifyAtHour = 9;

    for (final day in daysList) {
      if (day < 0) continue; // Do not schedule for negative days

      final scheduledAt = expireOn.subtract(Duration(days: day));
      if (scheduledAt.isBefore(now)) {
        continue; // Do not schedule for past dates
      }

      final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'benefit-reminder-$day',
          '期限リマインダー ($day日前)',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: const DarwinNotificationDetails(),
      );

      final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
        scheduledAt.copyWith(hour: notifyAtHour, minute: 0, second: 0),
        tz.local,
      );
      
      // Create a unique ID for each notification to avoid collisions
      final notificationId = (b.id! * 1000) + day;

      await _plugin.zonedSchedule(
        notificationId,
        '優待の期限が近づいています',
        '「${b.companyName}」の期限が${day == 0 ? "本日" : "$day日後"}です。',
        scheduledDate,
        notificationDetails,
        payload: idStr, // Use the same payload to group notifications by benefit
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }
}
