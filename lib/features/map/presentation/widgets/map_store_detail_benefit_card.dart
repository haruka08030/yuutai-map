import 'package:flutter/material.dart';

import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/core/utils/date_utils.dart';
import 'package:flutter_stock/features/benefits/domain/entities/users_yuutai.dart';

const Color _kExpiryRed = Color(0xFFEF4444);
const Color _kExpiryRedBg = Color(0x19EF4343);
const Color _kBenefitBg = Color(0x7FF1F4F8);

class MapStoreDetailBenefitCard extends StatelessWidget {
  const MapStoreDetailBenefitCard({super.key, required this.benefit});

  final UsersYuutai benefit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kBenefitBg,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.card_giftcard_rounded,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  benefit.benefitDetail ?? benefit.companyName,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (benefit.expiryDate != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _kExpiryRedBg,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  ),
                  child: Text(
                    getExpiryShortLabel(benefit.expiryDate!),
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: _kExpiryRed,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ],
          ),
          if (benefit.benefitDetail != null &&
              benefit.benefitDetail!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              benefit.benefitDetail!,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: AppTheme.secondaryTextColor(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
