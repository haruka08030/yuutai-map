import 'package:flutter/material.dart';
import 'package:flutter_stock/core/utils/url_launcher_utils.dart';
import 'package:flutter_stock/features/map/presentation/state/place.dart';

/// 店舗詳細ページの上部：カテゴリ・店名・住所・Googleマップボタン
class StoreDetailHeader extends StatelessWidget {
  const StoreDetailHeader({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest
          .withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (place.category != null) ...[
            _CategoryChip(label: place.category!),
            const SizedBox(height: 8),
          ],
          Text(
            place.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (place.address != null) ...[
            const SizedBox(height: 8),
            _AddressRow(address: place.address!),
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
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _AddressRow extends StatelessWidget {
  const _AddressRow({required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.location_on_outlined, size: 18),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            address,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
