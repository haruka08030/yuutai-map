import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/app/widgets/empty_state_view.dart';
import 'package:flutter_stock/core/utils/url_launcher_utils.dart';

const String _inquiryUrl =
    'https://forms.gle/VGyP1fZV8EPi56nc7'; // Define inquiry URL

class CompanySearchEmptyStateWithRequest extends ConsumerWidget {
  const CompanySearchEmptyStateWithRequest({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EmptyStateView(
          icon: Icons.business_outlined,
          title: '企業が見つかりません',
          subtitle: '入力した「$query」をそのまま使用できます',
          actionLabel: '「$query」を使用する',
          onActionPressed: () => Navigator.of(context).pop(query),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => launchURL(_inquiryUrl, context),
          icon: const Icon(Icons.send_rounded),
          label: const Text(
            '見つからない企業をリクエスト',
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
