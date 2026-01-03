import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/features/benefits/widgets/users_yuutai_list_tile.dart';
import 'package:flutter_stock/features/benefits/widgets/users_yuutai_skeleton_tile.dart'; // New Import
import 'package:flutter_stock/app/theme/app_theme.dart';

final _benefitsTabProvider = StateProvider.autoDispose<int>((ref) => 0);

class UsersYuutaiPage extends ConsumerWidget {
  const UsersYuutaiPage({
    super.key,
    required this.searchQuery,
    this.selectedFolderId,
  });

  final String searchQuery;
  final String? selectedFolderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final curTab = ref.watch(_benefitsTabProvider);
    final asyncBenefits = curTab == 0
        ? ref.watch(activeUsersYuutaiProvider)
        : ref.watch(historyUsersYuutaiProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(
                  value: 0,
                  label: Text('保有中'),
                  icon: Icon(Icons.confirmation_number_outlined),
                ),
                ButtonSegment(
                  value: 1,
                  label: Text('使用済み'),
                  icon: Icon(Icons.history),
                ),
              ],
              selected: {curTab},
              onSelectionChanged: (newSelection) {
                ref.read(_benefitsTabProvider.notifier).state =
                    newSelection.first;
              },
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
        ),
        Expanded(
          child: asyncBenefits.when(
            loading: () => ListView.builder(
              itemCount: 8,
              itemBuilder: (_, __) => const UsersYuutaiSkeletonTile(),
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
                final cs = Theme.of(context).colorScheme;
                final fg = cs.onSurface.withAlpha(165);
                final sub = cs.onSurface.withAlpha(114);
                
                if (curTab == 1) {
                   return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.history_toggle_off, size: 64, color: fg),
                        const SizedBox(height: 12),
                        Text('使用履歴がありません',
                            style: TextStyle(fontSize: 16, color: fg)),
                      ],
                    ),
                  );
                }

                if (searchQuery.isNotEmpty) {
                  return const Center(child: Text('該当する優待が見つかりません。'));
                }
                
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.inbox_outlined, size: 64, color: fg),
                      const SizedBox(height: 12),
                      Text('優待がありません',
                          style: TextStyle(fontSize: 16, color: fg)),
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
          ),
        ),
      ],
    );
  }
}
