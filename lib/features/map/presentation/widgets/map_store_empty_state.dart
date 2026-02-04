import 'package:flutter/material.dart';
import 'package:flutter_stock/core/utils/url_launcher_utils.dart';
import 'package:flutter_stock/core/widgets/empty_state_view.dart';

/// 店舗情報の不備・追加依頼用のGoogleフォーム
const String _storeDataRequestUrl = 'https://forms.gle/VGyP1fZV8EPi56nc7';

class MapStoreEmptyState extends StatelessWidget {
  const MapStoreEmptyState({
    super.key,
    required this.query,
    this.onClearPressed,
  });

  final String query;

  /// 食べログ風: 検索・条件をクリアしてやり直す
  final VoidCallback? onClearPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EmptyStateView(
          icon: Icons.store_outlined,
          title: '店舗が見つかりません',
          subtitle: '「$query」に一致する店舗はありません',
        ),
        const SizedBox(height: 20),
        if (onClearPressed != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OutlinedButton.icon(
              onPressed: onClearPressed,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: const Text('検索をクリア'),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
          ),
        ElevatedButton.icon(
          onPressed: () => launchURL(_storeDataRequestUrl, context),
          icon: const Icon(Icons.send_rounded),
          label: const Text(
            '店舗情報の修正・追加',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        ),
      ],
    );
  }
}
