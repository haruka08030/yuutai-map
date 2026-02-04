import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/benefits/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/features/benefits/provider/company_provider.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/features/benefits/widgets/users_yuutai_list_tile.dart';
import 'package:flutter_stock/features/map/presentation/state/place.dart';

/// 店舗詳細ページの「利用可能な優待」セクション
class StoreDetailBenefitsSection extends ConsumerWidget {
  const StoreDetailBenefitsSection({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final benefitsAsync = ref.watch(activeUsersYuutaiProvider);

    return Padding(
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
              final matching = benefits
                  .where((b) => b.companyId == place.companyId)
                  .toList();
              return _BenefitsList(matchingBenefits: matching);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text('エラー: $error'),
          ),
        ],
      ),
    );
  }
}

/// 優待一覧（証券コード取得のため ref が必要）
class _BenefitsList extends ConsumerWidget {
  const _BenefitsList({required this.matchingBenefits});

  final List<UsersYuutai> matchingBenefits;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (matchingBenefits.isEmpty) {
      return _EmptyBenefits();
    }

    final companyIds = matchingBenefits
        .map((b) => b.companyId)
        .whereType<int>()
        .toSet()
        .toList();
    final stockCodesAsync = ref.watch(companyStockCodesProvider(companyIds));
    final stockCodeMap =
        stockCodesAsync.whenOrNull(data: (m) => m) ?? <int, String>{};

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: matchingBenefits.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final b = matchingBenefits[index];
        final code = b.companyId != null ? stockCodeMap[b.companyId] : null;
        return UsersYuutaiListTile(
          benefit: b,
          stockCode: (code != null && code.isNotEmpty) ? code : null,
        );
      },
    );
  }
}

class _EmptyBenefits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}
