import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:flutter_stock/core/notifications/notification_service.dart';
import 'package:flutter_stock/features/settings/data/notification_settings_repository.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final pendingNotificationsProvider = FutureProvider<List<PendingNotificationRequest>>((ref) {
  final service = ref.watch(notificationServiceProvider);
  return service.getPendingNotifications();
});

class NotificationSettingsPage extends ConsumerWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultDays = ref.watch(defaultNotifyDaysProvider);
    final pendingNotifications = ref.watch(pendingNotificationsProvider);
    final activeBenefitsAsync = ref.watch(activeUsersYuutaiProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('通知設定'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'デフォルトの通知タイミング'),
          _buildDefaultTimingSettings(context, ref, defaultDays),
          const Divider(),
          _buildSectionHeader(context, '予約済みの通知一覧'),
          pendingNotifications.when(
            data: (notifications) {
              if (notifications.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: Text('予約済みの通知はありません')),
                );
              }

              // Sort notifications by date if possible (though PendingNotificationRequest doesn't easily expose date)
              // For now, just list them.
              return Column(
                children: notifications.map((n) {
                  final benefit = activeBenefitsAsync.value?.firstWhereOrNull(
                    (b) => b.id.toString() == n.payload,
                  );
                  
                  return ListTile(
                    leading: const Icon(Icons.notifications_active_outlined),
                    title: Text(benefit?.companyName ?? '不明な優待'),
                    subtitle: Text(n.body ?? ''),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        try {
                          await ref.read(notificationServiceProvider).cancelNotification(n.id);
                          ref.invalidate(pendingNotificationsProvider);
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('通知の削除に失敗しました: $e')),
                            );
                          }
                        }
                      },
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('エラーが発生しました: $err')),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildDefaultTimingSettings(BuildContext context, WidgetRef ref, List<int> currentDays) {
    final options = {
      30: '30日前',
      7: '7日前',
      3: '3日前',
      1: '1日前',
      0: '当日',
    };

    return Column(
      children: options.entries.map((entry) {
        final day = entry.key;
        final label = entry.value;
        final isSelected = currentDays.contains(day);

        return CheckboxListTile(
          title: Text(label),
          value: isSelected,
          onChanged: (checked) {
            final newList = List<int>.from(currentDays);
            if (checked == true) {
              newList.add(day);
            } else {
              newList.remove(day);
            }
            ref.read(defaultNotifyDaysProvider.notifier).updateDays(newList);
          },
        );
      }).toList(),
    );
  }
}
