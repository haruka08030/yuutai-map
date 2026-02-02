import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/core/widgets/empty_state_view.dart';
import 'package:flutter_stock/core/utils/url_launcher_utils.dart';

/// 企業情報の不備・追加依頼用のGoogleフォーム
const String _storeDataRequestUrl = 'https://forms.gle/VGyP1fZV8EPi56nc7';

class CompanySearchEmptyRequest extends ConsumerWidget {
  const CompanySearchEmptyRequest({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EmptyStateView(
          icon: Icons.business_outlined,
          title: '一致する企業が見つかりません',
          subtitle: '入力した「$query」はそのまま使用できます',
          actionLabel: '「$query」を追加する',
          onActionPressed: () => Navigator.of(context).pop(query),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => launchURL(_storeDataRequestUrl, context),
          icon: const Icon(Icons.send_rounded),
          label: const Text(
            '企業の追加をリクエスト',
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
