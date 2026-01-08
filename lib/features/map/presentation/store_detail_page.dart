import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/features/map/presentation/state/place.dart';
import 'package:flutter_stock/features/benefits/widgets/users_yuutai_list_tile.dart';
import 'package:flutter_stock/core/utils/url_launcher_utils.dart';

class StoreDetailPage extends ConsumerWidget {
  const StoreDetailPage({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final benefitsAsync = ref.watch(activeUsersYuutaiProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('店舗詳細')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Store Info Header
            Container(
              padding: const EdgeInsets.all(24),
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (place.category != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            place.category!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    place.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (place.address != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on_outlined, size: 18),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            place.address!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => launchGoogleMaps(
                      context: context,
                      latitude: place.latLng.latitude,
                      longitude: place.latLng.longitude,
                    ),
                    icon: const Icon(Icons.map_outlined),
                    label: const Text('Googleマップで開く'),
                  ),
                ],
              ),
            ),

            // Benefits Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '利用可能な優待',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  benefitsAsync.when(
                    data: (benefits) {
                      final matchingBenefits = benefits
                          .where((b) => b.companyId == place.companyId)
                          .toList();

                      if (matchingBenefits.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.card_giftcard_outlined,
                                  size: 48,
                                  color: Theme.of(context).disabledColor,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'この店舗で利用可能な優待はありません',
                                  style: TextStyle(
                                    color: Theme.of(context).disabledColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: matchingBenefits.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          return UsersYuutaiListTile(
                            benefit: matchingBenefits[index],
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Text('エラー: $error'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
