import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/features/benefits/provider/yuutai_list_settings_provider.dart';
import 'package:flutter_stock/features/benefits/domain/yuutai_list_settings.dart';
import 'package:flutter_stock/features/benefits/widgets/users_yuutai_list_tile.dart';
import 'package:flutter_stock/features/benefits/widgets/users_yuutai_skeleton_tile.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/app/widgets/empty_state_view.dart';
import 'package:flutter_stock/app/widgets/app_error_view.dart';
import 'package:flutter_stock/core/exceptions/app_exception.dart';
import 'package:flutter_stock/domain/entities/users_yuutai.dart';

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
    final settings = ref.watch(yuutaiListSettingsProvider);
    final settingsNotifier = ref.read(yuutaiListSettingsProvider.notifier);

    final asyncBenefits = !showHistory
        ? ref.watch(activeUsersYuutaiProvider)
        : ref.watch(historyUsersYuutaiProvider);

    return Column(
      children: [
        _buildSortBar(context, settings, settingsNotifier),
        Expanded(
          child: asyncBenefits.when(
            loading: () => ListView.builder(
              itemCount: 8,
              itemBuilder: (context, index) => const UsersYuutaiSkeletonTile(),
            ),
            error: (err, stack) => AppErrorView(
              message: AppException.from(err).message,
              onRetry: () => ref.invalidate(activeUsersYuutaiProvider),
            ),
            data: (data) {
              var items = data;

              // Apply folder filter from URL or settings
              final effectiveFolderId = selectedFolderId ?? settings.folderId;
              if (effectiveFolderId != null) {
                items = items
                    .where((benefit) => benefit.folderId == effectiveFolderId)
                    .toList();
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

              // Apply Sorting
              switch (settings.sortOrder) {
                case YuutaiSortOrder.expiryDate:
                  // For expiryDate, we keep nulls (no expiry) at the end
                  items.sort((a, b) {
                    if (a.expiryDate == null && b.expiryDate == null) return 0;
                    if (a.expiryDate == null) return 1;
                    if (b.expiryDate == null) return -1;
                    return a.expiryDate!.compareTo(b.expiryDate!);
                  });
                  break;
                case YuutaiSortOrder.companyName:
                  items.sort((a, b) => a.companyName.compareTo(b.companyName));
                  break;
                case YuutaiSortOrder.createdAt:
                  // id is auto-incrementing in many cases, or we can use id as proxy for creation order
                  // If we had createdAt in UsersYuutai, we would use that.
                  // For now, let's sort by id descending (newest first)
                  items.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
                  break;
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

              if (showHistory) {
                return _buildSimpleList(items);
              }

              // Grouping logic (Only if sorting by expiry date)
              if (settings.sortOrder == YuutaiSortOrder.expiryDate) {
                final expiringSoon = items.where((b) {
                  if (b.expiryDate == null) return false;
                  final today = DateTime.now();
                  final diff = DateTime(
                          b.expiryDate!.year, b.expiryDate!.month, b.expiryDate!.day)
                      .difference(DateTime(today.year, today.month, today.day))
                      .inDays;
                  return diff >= 0 && diff <= 30;
                }).toList();

                final others =
                    items.where((b) => !expiringSoon.contains(b)).toList();

                return ListView(
                  children: [
                    if (expiringSoon.isNotEmpty) ...[
                      _buildSectionHeader(
                          context, '期限間近', Icons.timer_outlined, Colors.orange),
                      ...expiringSoon.map((b) => _buildTile(b)),
                      const SizedBox(height: 16),
                    ],
                    if (others.isNotEmpty) ...[
                      if (expiringSoon.isNotEmpty)
                        _buildSectionHeader(
                            context, 'すべて', Icons.list_alt, null),
                      ...others.map((b) => _buildTile(b)),
                    ],
                  ],
                );
              }

              // Plain list for other sort orders
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) => _buildTile(items[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSortBar(BuildContext context, YuutaiListSettings settings,
      YuutaiListSettingsNotifier notifier) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _SortChip(
            label: '期限順',
            selected: settings.sortOrder == YuutaiSortOrder.expiryDate,
            onSelected: (_) => notifier.setSortOrder(YuutaiSortOrder.expiryDate),
          ),
          const SizedBox(width: 8),
          _SortChip(
            label: '企業名順',
            selected: settings.sortOrder == YuutaiSortOrder.companyName,
            onSelected: (_) => notifier.setSortOrder(YuutaiSortOrder.companyName),
          ),
          const SizedBox(width: 8),
          _SortChip(
            label: '新着順',
            selected: settings.sortOrder == YuutaiSortOrder.createdAt,
            onSelected: (_) => notifier.setSortOrder(YuutaiSortOrder.createdAt),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, IconData icon, Color? color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Icon(icon, 
               size: 18, 
               color: color ?? Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color ?? Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(UsersYuutai b) {
    return Column(
      children: [
        UsersYuutaiListTile(
          benefit: b,
          subtitle:
              (b.benefitDetail?.isNotEmpty ?? false) ? b.benefitDetail : null,
        ),
        Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: 1,
              thickness: 0.5,
              color: AppTheme.dividerColor(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleList(List<UsersYuutai> items) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Divider(
          height: 1,
          thickness: 0.5,
          color: AppTheme.dividerColor(context),
        ),
      ),
      itemBuilder: (context, index) {
        final b = items[index];
        return UsersYuutaiListTile(
          benefit: b,
          subtitle:
              (b.benefitDetail?.isNotEmpty ?? false) ? b.benefitDetail : null,
        );
      },
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: selected
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      selected: selected,
      onSelected: onSelected,
      selectedColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      visualDensity: VisualDensity.compact,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
    );
  }
}
