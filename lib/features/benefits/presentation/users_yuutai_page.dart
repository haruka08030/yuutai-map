import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/features/benefits/provider/yuutai_list_settings_provider.dart';
import 'package:flutter_stock/features/benefits/domain/yuutai_list_settings.dart';
import 'package:flutter_stock/features/benefits/widgets/users_yuutai_list_tile.dart';
import 'package:flutter_stock/features/benefits/widgets/users_yuutai_skeleton_tile.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/core/widgets/empty_state_view.dart';
import 'package:flutter_stock/core/widgets/app_error_view.dart';
import 'package:flutter_stock/core/exceptions/app_exception.dart';
import 'package:flutter_stock/features/benefits/domain/entities/users_yuutai.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:google_fonts/google_fonts.dart';

class UsersYuutaiPage extends ConsumerStatefulWidget {
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
  ConsumerState<UsersYuutaiPage> createState() => _UsersYuutaiPageState();
}

class _UsersYuutaiPageState extends ConsumerState<UsersYuutaiPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(yuutaiListSettingsProvider);
    final isGuest = ref.watch(isGuestProvider);
    final settingsNotifier = ref.read(yuutaiListSettingsProvider.notifier);

    final asyncBenefits = !widget.showHistory
        ? ref.watch(activeUsersYuutaiProvider)
        : ref.watch(historyUsersYuutaiProvider);

    return Scaffold(
      body: Column(
        children: [
          _buildFilterBar(context, settings, settingsNotifier),
          Expanded(
            child: asyncBenefits.when(
              loading: () => ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) =>
                    const UsersYuutaiSkeletonTile(),
              ),
              error: (err, stack) => AppErrorView(
                message: AppException.from(err).message,
                onRetry: () => ref.invalidate(activeUsersYuutaiProvider),
              ),
              data: (data) {
                var items = data;

                // Apply folder filter from URL or settings
                final effectiveFolderId =
                    widget.selectedFolderId ?? settings.folderId;
                if (effectiveFolderId != null) {
                  items = items
                      .where((benefit) => benefit.folderId == effectiveFolderId)
                      .toList();
                }

                if (widget.searchQuery.isNotEmpty) {
                  items = items.where((benefit) {
                    final query = widget.searchQuery.toLowerCase();
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
                      if (a.expiryDate == null && b.expiryDate == null) {
                        return 0;
                      }
                      if (a.expiryDate == null) {
                        return 1;
                      }
                      if (b.expiryDate == null) {
                        return -1;
                      }
                      return a.expiryDate!.compareTo(b.expiryDate!);
                    });
                    break;
                  case YuutaiSortOrder.companyName:
                    items.sort(
                      (a, b) => a.companyName.compareTo(b.companyName),
                    );
                    break;
                  case YuutaiSortOrder.createdAt:
                    // id is auto-incrementing in many cases, or we can use id as proxy for creation order
                    // If we had createdAt in UsersYuutai, we would use that.
                    // For now, let's sort by id descending (newest first)
                    items.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
                    break;
                }

                if (items.isEmpty) {
                  if (widget.showHistory) {
                    return const EmptyStateView(
                      icon: Icons.history_toggle_off,
                      title: '使用履歴がありません',
                      subtitle: '使用した優待はここに表示されます',
                    );
                  }

                  if (widget.searchQuery.isNotEmpty) {
                    return EmptyStateView(
                      icon: Icons.search_off,
                      title: '「${widget.searchQuery}」は見つかりませんでした',
                      subtitle: '別のキーワードで試してみてください',
                    );
                  }

                  return EmptyStateView(
                    imagePath: 'assets/images/empty_state.png',
                    title: '優待を登録しよう！',
                    subtitle: isGuest
                        ? 'ログインすると優待を登録して管理できます'
                        : '右下の「＋」ボタンから追加できます',
                  );
                }

                if (widget.showHistory) {
                  return _buildSimpleList(items);
                }

                if (settings.sortOrder == YuutaiSortOrder.expiryDate) {
                  final expiringSoon = items.where((b) {
                    if (b.expiryDate == null) return false;
                    final today = DateTime.now();
                    final diff =
                        DateTime(
                              b.expiryDate!.year,
                              b.expiryDate!.month,
                              b.expiryDate!.day,
                            )
                            .difference(
                              DateTime(today.year, today.month, today.day),
                            )
                            .inDays;
                    return diff >= 0 && diff <= 30;
                  }).toList();

                  final others = items
                      .where((b) => !expiringSoon.contains(b))
                      .toList();

                  return ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      if (expiringSoon.isNotEmpty) ...[
                        _buildSectionHeader(
                          context,
                          '期限間近',
                          Icons.timer_outlined,
                          const Color(0xFFEF4444),
                        ),
                        ...expiringSoon.map((b) => _buildTile(b)),
                        const SizedBox(height: 24),
                      ],
                      if (others.isNotEmpty) ...[
                        if (expiringSoon.isNotEmpty)
                          _buildSectionHeader(
                            context,
                            'すべて',
                            Icons.list_alt_rounded,
                            null,
                          ),
                        ...others.map((b) => _buildTile(b)),
                      ],
                    ],
                  );
                }

                // Plain list for other sort orders
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: items.length,
                  itemBuilder: (context, index) => _buildTile(items[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isGuest
          ? null
          : FloatingActionButton(
              onPressed: () => context.push('/yuutai/add'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              elevation: 4,
              child: const Icon(Icons.add, size: 28),
            ),
    );
  }

  Widget _buildFilterBar(
    BuildContext context,
    YuutaiListSettings settings,
    YuutaiListSettingsNotifier notifier,
  ) {
    return Container(
      decoration: BoxDecoration(
        color:
            Theme.of(context).appBarTheme.backgroundColor ??
            Theme.of(context).colorScheme.surface, // Match AppBar background
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _SortChip(
              label: '期限順',
              selected: settings.sortOrder == YuutaiSortOrder.expiryDate,
              onSelected: (_) =>
                  notifier.setSortOrder(YuutaiSortOrder.expiryDate),
            ),
            const SizedBox(width: 8),
            _SortChip(
              label: '企業名順',
              selected: settings.sortOrder == YuutaiSortOrder.companyName,
              onSelected: (_) =>
                  notifier.setSortOrder(YuutaiSortOrder.companyName),
            ),
            const SizedBox(width: 8),
            _SortChip(
              label: '新着順',
              selected: settings.sortOrder == YuutaiSortOrder.createdAt,
              onSelected: (_) =>
                  notifier.setSortOrder(YuutaiSortOrder.createdAt),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    Color? color,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: color ?? Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color ?? Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(UsersYuutai b) {
    return UsersYuutaiListTile(
      benefit: b,
      subtitle: (b.benefitDetail?.isNotEmpty ?? false) ? b.benefitDetail : null,
    );
  }

  Widget _buildSimpleList(List<UsersYuutai> items) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildTile(items[index]),
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
        style: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          color: selected ? Colors.white : AppTheme.secondaryTextColor(context),
        ),
      ),
      selected: selected,
      onSelected: onSelected,
      selectedColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Colors.transparent,
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      visualDensity: VisualDensity.compact,
      elevation: 0,
      pressElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: selected
              ? Theme.of(context).colorScheme.primary
              : AppTheme.dividerColor(context),
          width: 1,
        ),
      ),
    );
  }
}
