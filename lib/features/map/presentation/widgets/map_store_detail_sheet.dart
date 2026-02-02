import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_stock/features/benefits/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/features/map/presentation/state/place.dart';
import 'package:flutter_stock/core/utils/date_utils.dart';

const Color _kMapAccent = Color(0xFF2DD4BF);
const Color _kTextPrimary = Color(0xFF1E293B);
const Color _kTextSecondary = Color(0xFF64748B);
const Color _kOpenGreen = Color(0xFF009865);
const Color _kOpenGreenBg = Color(0xFFEBFCF4);
const Color _kUseNowOrange = Color(0xFFFB923C);
const Color _kExpiryRed = Color(0xFFEF4444);
const Color _kExpiryRedBg = Color(0x19EF4343);
const Color _kBenefitBg = Color(0x7FF1F4F8);
const Color _kStoreIconRed = Color(0xFFFEF2F2);
const Color _kShareButtonBg = Color(0xFFF1F5F9);

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
                  // Store row: icon, name, OPEN, distance
                  Row(
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
                                    style: GoogleFonts.outfit(
                                      color: _kTextPrimary,
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
                                      style: GoogleFonts.outfit(
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
                                style: GoogleFonts.outfit(
                                  color: _kTextSecondary,
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
                            style: GoogleFonts.outfit(
                              color: _kMapAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '徒歩$walkMin分',
                            style: GoogleFonts.outfit(
                              color: _kTextSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Benefit section
                  benefitsAsync.when(
                    data: (benefits) {
                      final matching = benefits
                          .where((b) =>
                              b.companyId != null &&
                              b.companyId == place.companyId)
                          .toList();
                      final benefit =
                          matching.isNotEmpty ? matching.first : null;
                      if (benefit == null) {
                        return const SizedBox.shrink();
                      }
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _kBenefitBg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.card_giftcard_rounded,
                                  size: 20,
                                  color: _kMapAccent,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    benefit.benefitDetail ??
                                        benefit.companyName,
                                    style: GoogleFonts.outfit(
                                      color: _kTextPrimary,
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
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      _expiryLabel(benefit),
                                      style: GoogleFonts.outfit(
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
                                style: GoogleFonts.outfit(
                                  color: _kTextSecondary,
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
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 24),
                  // Use Now + Share
                  Row(
                    children: [
                      Expanded(
                        child: Material(
                          color: _kUseNowOrange,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              context.push('/store/detail', extra: place);
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              height: 56,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.confirmation_number_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '使う',
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Material(
                        color: _kShareButtonBg,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('共有機能は準備中です'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: const SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(
                              Icons.share_rounded,
                              color: _kTextPrimary,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _expiryLabel(UsersYuutai b) {
    if (b.expiryDate == null) return '';
    final days = calculateDaysRemaining(b.expiryDate!);
    if (days < 0) return '期限切れ';
    if (days == 0) return '本日まで';
    if (days == 1) return '明日まで';
    return 'あと$days日';
  }
}
