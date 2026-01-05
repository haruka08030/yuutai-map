import 'package:flutter/material.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/core/utils/date_utils.dart';
import 'package:flutter_stock/domain/entities/users_yuutai.dart'; // To get benefit.expiryDate

class ExpiryDateDisplay extends StatelessWidget {
  const ExpiryDateDisplay({
    super.key,
    required this.benefit,
    required this.isUsed,
    this.daysRemaining,
  });

  final UsersYuutai benefit;
  final bool isUsed;
  final int? daysRemaining;

  @override
  Widget build(BuildContext context) {
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
