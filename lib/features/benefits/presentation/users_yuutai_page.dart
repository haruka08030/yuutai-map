import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/features/benefits/widgets/users_yuutai_list_tile.dart';
import 'package:flutter_stock/features/benefits/widgets/users_yuutai_skeleton_tile.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/app/widgets/empty_state_view.dart';



class UsersYuutaiPage extends ConsumerWidget {
  const UsersYuutaiPage({
    super.key,
    required this.searchQuery,
    this.selectedFolderId,
    this.showHistory = false,
  });

  final String searchQuery;
  final String? selectedFolderId;
  final bool showHistory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBenefits = !showHistory
        ? ref.watch(activeUsersYuutaiProvider)
        : ref.watch(historyUsersYuutaiProvider);

    return Column(
      children: [
        Expanded(
          child: asyncBenefits.when(
            loading: () => ListView.builder(
              itemCount: 8,
              itemBuilder: (context, index) => const UsersYuutaiSkeletonTile(),
            ),
            error: (err, stack) => Center(child: Text('エラー: $err')),
            data: (data) {
              var items = data;
              
              // Apply folder filter
              if (selectedFolderId != null) {
                items = items.where((benefit) => benefit.folderId == selectedFolderId).toList();
              }
              
              if (searchQuery.isNotEmpty) {
                items = items.where((benefit) {
                  final query = searchQuery.toLowerCase();
                  final title = benefit.companyName.toLowerCase();
                  final benefitText =
                      benefit.benefitDetail?.toLowerCase() ?? '';
                  return title.contains(query) || benefitText.contains(query);
                }).toList();
              }

              if (items.isEmpty) {
                if (showHistory) {
                  return const EmptyStateView(
                    icon: Icons.history_toggle_off,
                    title: '使用履歴がありません',
                    subtitle: '使用した優待はここに表示されます',
                  );
                }

                if (searchQuery.isNotEmpty) {
                  return EmptyStateView(
                    icon: Icons.search_off,
                    title: '「$searchQuery」は見つかりませんでした',
                    subtitle: '別のキーワードで試してみてください',
                  );
                }

                return const EmptyStateView(
                  icon: Icons.inbox_outlined,
                  title: '優待を登録しよう！',
                  subtitle: '右下の「＋」ボタンから追加できます',
                );
              }

              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, _) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
          ),
        ),
      ],
    );
  }
}
