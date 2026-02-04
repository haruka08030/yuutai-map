import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/features/map/presentation/state/place.dart';
import 'package:flutter_stock/features/map/presentation/widgets/map_store_detail_actions.dart';
import 'package:flutter_stock/features/map/presentation/widgets/map_store_detail_benefit_card.dart';
import 'package:flutter_stock/features/map/presentation/widgets/map_store_detail_header.dart';

/// Shows a bottom sheet with store info and first matching benefit (design style).
Future<void> showMapStoreDetailSheet({
  required BuildContext context,
  required Place place,
  required double currentLat,
  required double currentLng,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => MapStoreDetailSheet(
      place: place,
      currentLat: currentLat,
      currentLng: currentLng,
    ),
  );
}

class MapStoreDetailSheet extends ConsumerWidget {
  const MapStoreDetailSheet({
    super.key,
    required this.place,
    required this.currentLat,
    required this.currentLng,
  });

  final Place place;
  final double currentLat;
  final double currentLng;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final benefitsAsync = ref.watch(activeUsersYuutaiProvider);
    final distanceM = Geolocator.distanceBetween(
      currentLat,
      currentLng,
      place.latLng.latitude,
      place.latLng.longitude,
    );
    final distanceStr = distanceM >= 1000
        ? '${(distanceM / 1000).toStringAsFixed(1)}km'
        : '${distanceM.round()}m';
    final walkMin = (distanceM / 80).ceil().clamp(1, 999);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 25,
            offset: Offset(0, 20),
            spreadRadius: -5,
          ),
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 10,
            offset: Offset(0, 8),
            spreadRadius: -6,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 13),
            Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MapStoreDetailHeader(
                    place: place,
                    distanceStr: distanceStr,
                    walkMin: walkMin,
                  ),
                  const SizedBox(height: 16),
                  benefitsAsync.when(
                    data: (benefits) {
                      final matching = benefits
                          .where((benefit) =>
                              benefit.companyId != null &&
                              benefit.companyId == place.companyId)
                          .toList();
                      final benefit =
                          matching.isNotEmpty ? matching.first : null;
                      if (benefit == null) {
                        return const SizedBox.shrink();
                      }
                      return MapStoreDetailBenefitCard(benefit: benefit);
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 24),
                  MapStoreDetailActions(place: place),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
