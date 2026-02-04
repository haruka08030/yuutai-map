import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/benefits/domain/entities/benefit_status.dart';
import 'package:flutter_stock/features/benefits/domain/entities/users_yuutai.dart';
import 'package:timezone/timezone.dart' as tz;

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService {
  NotificationService();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

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
    await _plugin.initialize(settings: settings);
  }

  Future<void> cancelAllFor(String id) async {
    final pending = await _plugin.pendingNotificationRequests();
    for (final p in pending) {
      if (p.payload == id) {
        await _plugin.cancel(id: p.id);
      }
    }
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _plugin.pendingNotificationRequests();
  }

  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id: id);
  }

  Future<void> reschedulePresetReminders(UsersYuutai benefit) async {
    if (benefit.id == null) return;
    final idStr = benefit.id.toString();
    await cancelAllFor(idStr);

    if (benefit.status == BenefitStatus.used || !benefit.alertEnabled) {
      return;
    }

    final expireOn = benefit.expiryDate;
    if (expireOn == null) {
      return;
    }

    final now = DateTime.now();
    if (expireOn.isBefore(now)) {
      return;
    }

    final daysList = benefit.notifyDaysBefore;
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
      // Ensure notification ID stays within 32-bit int range
      final notificationId = ((benefit.id! * 1000) + day) % 2147483647;

      await _plugin.zonedSchedule(
        id: notificationId,
        title: '優待の期限が近づいています',
        body: '「${benefit.companyName}」の期限が${day == 0 ? "本日" : "あと$day日"}です。',
        scheduledDate: scheduledDate,
        notificationDetails: notificationDetails,
        payload:
            idStr, // Use the same payload to group notifications by benefit
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }
}
