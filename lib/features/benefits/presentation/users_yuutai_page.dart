import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/features/benefits/widgets/users_yuutai_list_tile.dart';
import 'package:flutter_stock/app/widgets/app_loading_indicator.dart';
import 'package:flutter_stock/features/benefits/widgets/users_yuutai_skeleton_tile.dart'; // New Import
import 'package:flutter_stock/app/theme/app_theme.dart'; // New Import

class UsersYuutaiPage extends ConsumerWidget {
  const UsersYuutaiPage({super.key, required this.searchQuery});

  final String searchQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBenefits = ref.watch(activeUsersYuutaiProvider);

    return asyncBenefits.when(
      loading: () => ListView.builder(
        itemCount: 8, // Display 8 skeleton tiles
        itemBuilder: (_, __) => const UsersYuutaiSkeletonTile(),
      ),
      error: (err, stack) => Center(child: Text('エラー: $err')),
      data: (data) {
        var items = data;
        if (searchQuery.isNotEmpty) {
          items = items.where((benefit) {
            final query = searchQuery.toLowerCase();
            final title = benefit.companyName.toLowerCase();
            final benefitText = benefit.benefitDetail?.toLowerCase() ?? '';
            return title.contains(query) || benefitText.contains(query);
          }).toList();
        }

        if (items.isEmpty) {
          if (searchQuery.isNotEmpty) {
            return const Center(child: Text('該当する優待が見つかりません。'));
          }
          final cs = Theme.of(context).colorScheme;
          final fg = cs.onSurface.withAlpha(165);
          final sub = cs.onSurface.withAlpha(114);
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.inbox_outlined, size: 64, color: fg),
                const SizedBox(height: 12),
                Text('優待がありません', style: TextStyle(fontSize: 16, color: fg)),
                const SizedBox(height: 4),
                Text('右下の + から追加できます', style: TextStyle(color: sub)),
              ],
            ),
          );
        }

        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, _) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1, thickness: 0.5, color: AppTheme.dividerColor(context)),
          ),
          itemBuilder: (context, index) {
            final b = items[index];
            return UsersYuutaiListTile(
              benefit: b,
              subtitle: (b.benefitDetail?.isNotEmpty ?? false)
                  ? b.benefitDetail
                  : null,
            );
          },
        );
      },
    );
  }
}
