import 'package:flutter/material.dart';

import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/features/map/presentation/state/place.dart';

const Color _kOpenGreen = Color(0xFF009865);
const Color _kOpenGreenBg = Color(0xFFEBFCF4);
const Color _kExpiryRed = Color(0xFFEF4444);
const Color _kStoreIconRed = Color(0xFFFEF2F2);

/// 店舗ボトムシートのヘッダー（アイコン・店名・OPEN・住所・距離）
class MapStoreDetailHeader extends StatelessWidget {
  const MapStoreDetailHeader({
    super.key,
    required this.place,
    required this.distanceStr,
    required this.walkMin,
  });

  final Place place;
  final String distanceStr;
  final int walkMin;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: _kStoreIconRed,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.store_rounded,
            size: 32,
            color: _kExpiryRed,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      place.name,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (!place.isClosed) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _kOpenGreenBg,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'OPEN',
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: _kOpenGreen,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ],
                ],
              ),
              if (place.address != null) ...[
                const SizedBox(height: 2),
                Text(
                  place.address!,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppTheme.secondaryTextColor(context),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              distanceStr,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              '徒歩$walkMin分',
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: AppTheme.secondaryTextColor(context),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
