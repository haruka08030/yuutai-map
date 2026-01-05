import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/domain/entities/benefit_status.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';

import 'package:intl/intl.dart';

class UsersYuutaiListTile extends ConsumerWidget {
  const UsersYuutaiListTile({super.key, required this.benefit, this.subtitle});
  final UsersYuutai benefit;
  final String? subtitle;

  String _formatExpireDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year) {
      return DateFormat('MM/dd').format(date);
    }
    return DateFormat('yyyy/MM/dd').format(date);
  }

  int _calculateDaysRemaining(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expireDate = DateTime(date.year, date.month, date.day);
    return expireDate.difference(today).inDays;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(usersYuutaiRepositoryProvider);

    return Slidable(
      key: ValueKey(benefit.id),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            backgroundColor: Theme.of(context).extension<AppColors>()?.editActionBackground ?? Colors.white,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            icon: Icons.edit,
            label: '編集',
            onPressed: (_) {
              context.push('/yuutai/edit', extra: benefit);
            },
          ),
          SlidableAction(
            backgroundColor: Theme.of(context).extension<AppColors>()?.deleteActionBackground ?? Colors.white,
            foregroundColor: Theme.of(context).extension<AppColors>()?.deleteActionForeground ?? Colors.white,
            icon: Icons.delete,
            label: '削除',
            onPressed: (_) async {
              await HapticFeedback.lightImpact();
              if (!context.mounted) return;
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('削除しますか？'),
                  content: Text('「${benefit.companyName}」を削除します。取り消せません。'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('キャンセル'),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).extension<AppColors>()?.deleteActionBackground ?? Colors.white,
                      ),
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('削除'),
                    ),
                  ],
                ),
              );
              if (ok == true && benefit.id != null) {
                await HapticFeedback.heavyImpact();
                await repo.delete(benefit.id!);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('削除しました'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            backgroundColor: Theme.of(context).extension<AppColors>()?.editActionBackground ?? Colors.white,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            icon: Icons.edit,
            label: '編集',
            onPressed: (_) {
              context.push('/yuutai/edit', extra: benefit);
            },
          ),
          SlidableAction(
            backgroundColor: Theme.of(context).extension<AppColors>()?.deleteActionBackground ?? Colors.white,
            foregroundColor: Theme.of(context).extension<AppColors>()?.deleteActionForeground ?? Colors.white,
            icon: Icons.delete,
            label: '削除',
            onPressed: (_) async {
              await HapticFeedback.lightImpact();
              if (!context.mounted) return;
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('削除しますか？'),
                  content: Text('「${benefit.companyName}」を削除します。取り消せません。'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('キャンセル'),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).extension<AppColors>()?.deleteActionBackground ?? Colors.white,
                      ),
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('削除'),
                    ),
                  ],
                ),
              );
              if (ok == true && benefit.id != null) {
                await HapticFeedback.heavyImpact();
                await repo.delete(benefit.id!);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('削除しました'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          context.push('/yuutai/edit', extra: benefit);
        },
        child: Builder(
          builder: (context) {
            final hasSubtitle = benefit.expiryDate != null || subtitle != null;
            final isUsed = benefit.status == BenefitStatus.used;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                crossAxisAlignment: hasSubtitle
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.center,
                children: [
                  // チェックボックス
                  Checkbox(
                    value: isUsed,
                    onChanged: (v) async {
                      if (benefit.id == null) return;
                      await HapticFeedback.lightImpact();
                      final newStatus =
                          v ?? false ? BenefitStatus.used : BenefitStatus.active;
                      repo.updateStatus(benefit.id!, newStatus);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    activeColor: Theme.of(context).colorScheme.primary, // Themed primary color
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(width: 8),
                  // コンテンツ
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // タイトル（企業名）
                        Text(
                          benefit.companyName,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            decoration:
                                isUsed ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        // 期限日
                        if (benefit.expiryDate != null) ...[
                          const SizedBox(height: 5),
                          Builder(
                            builder: (context) {
                              final daysRemaining = _calculateDaysRemaining(benefit.expiryDate!);
                              final appColors = Theme.of(context).extension<AppColors>();
                              
                              Color color = AppTheme.secondaryTextColor(context);
                              IconData? icon;
                              
                              if (!isUsed) {
                                if (daysRemaining <= 7) {
                                  color = appColors?.expiringUrgent ?? Colors.red;
                                  icon = Icons.error_outline;
                                } else if (daysRemaining <= 30) {
                                  color = appColors?.expiringSoon ?? Colors.orange;
                                  icon = Icons.warning_amber_rounded;
                                }
                              }

                              return Row(
                                children: [
                                  if (icon != null) ...[
                                    Icon(icon, size: 14, color: color),
                                    const SizedBox(width: 4),
                                  ],
                                  Text(
                                    _formatExpireDate(benefit.expiryDate!),
                                    style: TextStyle(
                                      color: color,
                                      fontSize: 14,
                                      fontWeight: icon != null ? FontWeight.bold : FontWeight.normal,
                                      decoration: isUsed ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                                  if (!isUsed && daysRemaining >= 0) ...[
                                    const SizedBox(width: 8),
                                    Text(
                                      daysRemaining == 0 ? '本日まで' : 'あと$daysRemaining日',
                                      style: TextStyle(
                                        color: color,
                                        fontSize: 12,
                                        fontWeight: icon != null ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ],
                              );
                            },
                          ),
                        ],
                        // 優待内容
                        if (subtitle != null) ...[
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.benefitChipBackgroundColor(context), // Themed color
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              subtitle!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.primary, // Themed primary color
                                decoration: isUsed
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
