import 'package:flutter/material.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/core/utils/date_utils.dart';
import 'package:flutter_stock/features/benefits/domain/entities/users_yuutai.dart';

class ExpiryDateDisplay extends StatelessWidget {
  const ExpiryDateDisplay({
    super.key,
    required this.benefit,
    required this.isUsed,
    this.daysRemaining,
    this.useChipStyle = false,
  });

  final UsersYuutai benefit;
  final bool isUsed;
  final int? daysRemaining;

  /// 一覧カード用: 薄い緑のチップ＋カレンダーアイコン＋日付（日本語）
  final bool useChipStyle;

  @override
  Widget build(BuildContext context) {
    if (useChipStyle) {
      return _ExpiryDateChip(
        date: benefit.expiryDate!,
        isUsed: isUsed,
        daysRemaining: daysRemaining,
      );
    }

    final appColors = Theme.of(context).extension<AppColors>();
    Color color = AppTheme.secondaryTextColor(context);
    IconData? icon;

    if (!isUsed && daysRemaining != null) {
      if (daysRemaining! <= 7) {
        color = appColors?.expiringUrgent ?? Colors.red;
        icon = Icons.timer_outlined;
      } else if (daysRemaining! <= 30) {
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
          '期限: ${formatExpireDate(benefit.expiryDate!)}',
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: icon != null ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        if (!isUsed && daysRemaining != null && daysRemaining! >= 0) ...[
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
  }
}

/// 一覧カード用: 薄い緑の角丸チップにカレンダーアイコン＋日付（日本語）
class _ExpiryDateChip extends StatelessWidget {
  const _ExpiryDateChip({
    required this.date,
    required this.isUsed,
    this.daysRemaining,
  });

  final DateTime date;
  final bool isUsed;
  final int? daysRemaining;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>();
    Color chipBg = AppTheme.benefitChipBackgroundColor(context);
    Color chipFg = AppTheme.chipForegroundColor(context);
    if (!isUsed && daysRemaining != null) {
      if (daysRemaining! <= 7) {
        chipFg = appColors?.expiringUrgent ?? Colors.red;
        chipBg =
            (appColors?.expiringUrgent ?? Colors.red).withValues(alpha: 0.12);
      } else if (daysRemaining! <= 30) {
        chipFg = appColors?.expiringSoon ?? Colors.orange;
        chipBg =
            (appColors?.expiringSoon ?? Colors.orange).withValues(alpha: 0.12);
      }
    }
    if (isUsed) {
      chipFg = AppTheme.secondaryTextColor(context);
      chipBg = Theme.of(context).colorScheme.surfaceContainerHighest;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: chipBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today_rounded, size: 16, color: chipFg),
          const SizedBox(width: 6),
          Text(
            formatExpireDateJa(date),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: chipFg,
                ),
          ),
        ],
      ),
    );
  }
}
