import 'package:flutter/material.dart';

class MapStatusBanner extends StatelessWidget {
  final bool showAllStores;
  final bool isGuest;
  final bool bannerDismissed;
  final VoidCallback onShowAll;
  final VoidCallback onClose;

  const MapStatusBanner({
    super.key,
    required this.showAllStores,
    required this.isGuest,
    required this.bannerDismissed,
    required this.onShowAll,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    if (showAllStores || isGuest || bannerDismissed) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .secondaryContainer
                .withAlpha(242),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '保有優待の対象店舗のみ表示中です。',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                ),
              ),
              TextButton(
                onPressed: onShowAll,
                child: const Text('すべて表示'),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                iconSize: 20,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                onPressed: onClose,
              )
            ],
          ),
        ),
      ),
    );
  }
}
