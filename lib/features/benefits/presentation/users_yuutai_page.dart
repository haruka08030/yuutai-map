import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/core/exceptions/app_exception.dart';
import 'package:flutter_stock/core/widgets/app_error_view.dart';
import 'package:flutter_stock/core/widgets/empty_state_view.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/features/benefits/domain/entities/benefit_status.dart';
import 'package:flutter_stock/features/benefits/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/features/benefits/domain/yuutai_list_settings.dart';
import 'package:flutter_stock/features/benefits/presentation/widgets/add_yuutai_sheet.dart';
import 'package:flutter_stock/features/benefits/provider/company_provider.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/features/benefits/provider/yuutai_list_settings_provider.dart';
import 'package:flutter_stock/features/benefits/widgets/users_yuutai_list_tile.dart';
import 'package:flutter_stock/features/benefits/widgets/users_yuutai_skeleton_tile.dart';

// リスト・UI定数
const int _skeletonItemCount = 8;
const double _errorViewHeightOffset = 200;
const double _listPaddingVertical = 8;
const double _sectionSpacing = 24;
const double _expiringSoonDays = 30;
const double _filterChipSpacing = 8;
const double _searchSectionPaddingH = 16;
const double _searchSectionPaddingV = 12;
const double _sortIconSize = 18;
const double _sortLabelFontSize = 14;
const double _sectionHeaderPaddingL = 20;
const double _sectionHeaderPaddingR = 16;
const double _sectionHeaderPaddingV = 16;
const double _sectionHeaderTitleFontSize = 15;
const double _fabIconSize = 28;
const double _bottomSheetRadius = 16;
const double _bottomSheetPaddingV = 24;
const double _sortOptionPaddingH = 24;
const double _sortOptionPaddingV = 16;
const double _sortOptionTitleFontSize = 18;
const double _sortOptionLabelFontSize = 16;

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
    final companyIds = ref.watch(benefitCompanyIdsProvider(widget.showHistory));
    final stockCodesAsync = ref.watch(companyStockCodesProvider(companyIds));
    final stockCodeMap =
        stockCodesAsync.whenOrNull(data: (map) => map) ?? <int, String>{};

    final asyncBenefits = !widget.showHistory
        ? ref.watch(activeUsersYuutaiProvider)
        : ref.watch(historyUsersYuutaiProvider);

    final listProvider = widget.showHistory
        ? historyUsersYuutaiProvider
        : activeUsersYuutaiProvider;

    final surfaceColor = Theme.of(context).appBarTheme.backgroundColor ??
        Theme.of(context).colorScheme.surface;
    return Scaffold(
      backgroundColor: surfaceColor,
      body: Column(
        children: [
          _buildSearchAndFilterSection(context, settings, settingsNotifier),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(listProvider);
                await ref.read(listProvider.future);
              },
              child: asyncBenefits.when(
                loading: () => ListView.builder(
                  itemCount: _skeletonItemCount,
                  itemBuilder: (context, index) =>
                      const UsersYuutaiSkeletonTile(),
                ),
                error: (err, stack) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height -
                        _errorViewHeightOffset,
                    child: AppErrorView(
                      message: AppException.from(err).message,
                      onRetry: () => ref.invalidate(listProvider),
                    ),
                  ),
                ),
                data: (data) {
                  var items = data;

                  // Apply folder filter from URL or settings
                  final effectiveFolderId =
                      widget.selectedFolderId ?? settings.folderId;
                  if (effectiveFolderId != null) {
                    items = items
                        .where(
                            (benefit) => benefit.folderId == effectiveFolderId)
                        .toList();
                  }

                  // Apply search filter（企業名・優待内容・証券番号）
                  final searchQuery = widget.searchQuery;
                  if (searchQuery.isNotEmpty) {
                    items = items.where((benefit) {
                      final query = searchQuery.toLowerCase();
                      final title = benefit.companyName.toLowerCase();
                      final benefitText =
                          benefit.benefitDetail?.toLowerCase() ?? '';
                      final stockCode =
                          (stockCodeMap[benefit.companyId] ?? '').toLowerCase();
                      return title.contains(query) ||
                          benefitText.contains(query) ||
                          stockCode.contains(query);
                    }).toList();
                  }

                  items = _applyListFilter(items, settings.listFilter);
                  items = List<UsersYuutai>.from(items);

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
                    Widget emptyWidget;
                    if (widget.showHistory) {
                      emptyWidget = const EmptyStateView(
                        icon: Icons.history_toggle_off,
                        title: '使用履歴がありません',
                        subtitle: '使用した優待はここに表示されます',
                      );
                    } else {
                      final displayQuery = widget.searchQuery;
                      if (displayQuery.isNotEmpty) {
                        emptyWidget = EmptyStateView(
                          icon: Icons.search_off,
                          title: '「$displayQuery」は見つかりませんでした',
                          subtitle: '別のキーワードで試してみてください',
                        );
                      } else {
                        emptyWidget = EmptyStateView(
                          imagePath: 'assets/images/empty_state.png',
                          title: '優待を登録しよう！',
                          subtitle: isGuest
                              ? 'ログインすると優待を登録して管理できます'
                              : '右下の「＋」ボタンから追加できます',
                        );
                      }
                    }
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height -
                            _errorViewHeightOffset,
                        child: emptyWidget,
                      ),
                    );
                  }

                  if (widget.showHistory) {
                    return _buildSimpleList(
                      items,
                      settings.listFilter,
                      stockCodeMap,
                    );
                  }

                  if (settings.sortOrder == YuutaiSortOrder.expiryDate) {
                    final expiringSoon = items.where((b) {
                      if (b.expiryDate == null) return false;
                      final today = DateTime.now();
                      final diff = DateTime(
                        b.expiryDate!.year,
                        b.expiryDate!.month,
                        b.expiryDate!.day,
                      )
                          .difference(
                            DateTime(today.year, today.month, today.day),
                          )
                          .inDays;
                      return diff >= 0 && diff <= _expiringSoonDays;
                    }).toList();

                    final others =
                        items.where((b) => !expiringSoon.contains(b)).toList();

                    return ListView(
                      key: ValueKey(settings.listFilter),
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          vertical: _listPaddingVertical),
                      children: [
                        if (expiringSoon.isNotEmpty) ...[
                          _buildSectionHeader(
                            context,
                            '期限間近',
                            Icons.timer_outlined,
                            Theme.of(context)
                                    .extension<AppColors>()
                                    ?.expiringSoon ??
                                Theme.of(context).colorScheme.error,
                          ),
                          ...expiringSoon.map(
                              (b) => _buildTile(b, stockCodeMap[b.companyId])),
                          const SizedBox(height: _sectionSpacing),
                        ],
                        if (others.isNotEmpty) ...[
                          if (expiringSoon.isNotEmpty)
                            _buildSectionHeader(
                              context,
                              'すべて',
                              Icons.list_alt_rounded,
                              null,
                            ),
                          ...others.map(
                              (b) => _buildTile(b, stockCodeMap[b.companyId])),
                        ],
                      ],
                    );
                  }

                  // Plain list for other sort orders
                  return ListView.builder(
                    key: ValueKey(settings.listFilter),
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        vertical: _listPaddingVertical),
                    itemCount: items.length,
                    itemBuilder: (context, index) => _buildTile(
                      items[index],
                      stockCodeMap[items[index].companyId],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: isGuest
          ? null
          : FloatingActionButton(
              onPressed: () => YuutaiEditSheet.show(context),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              elevation: 4,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, size: _fabIconSize),
            ),
    );
  }

  Widget _buildSearchAndFilterSection(
    BuildContext context,
    YuutaiListSettings settings,
    YuutaiListSettingsNotifier notifier,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor ??
            Theme.of(context).colorScheme.surface,
      ),
      padding: const EdgeInsets.fromLTRB(
        _searchSectionPaddingH,
        _searchSectionPaddingV,
        _searchSectionPaddingH,
        _searchSectionPaddingV,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'すべて',
                  selected: !widget.showHistory &&
                      settings.listFilter == YuutaiListFilter.all,
                  onTap: () {
                    notifier.setListFilter(YuutaiListFilter.all);
                    if (widget.showHistory) {
                      context.go('/yuutai');
                    }
                  },
                ),
                const SizedBox(width: _filterChipSpacing),
                _FilterChip(
                  label: '期限間近',
                  selected:
                      settings.listFilter == YuutaiListFilter.expiringSoon,
                  onTap: () =>
                      notifier.setListFilter(YuutaiListFilter.expiringSoon),
                ),
                const SizedBox(width: _filterChipSpacing),
                _FilterChip(
                  label: '有効',
                  selected: settings.listFilter == YuutaiListFilter.active,
                  onTap: () => notifier.setListFilter(YuutaiListFilter.active),
                ),
                const SizedBox(width: _filterChipSpacing),
                _FilterChip(
                  label: '使用済み',
                  selected: settings.listFilter == YuutaiListFilter.used,
                  onTap: () {
                    if (widget.showHistory) {
                      notifier.setListFilter(YuutaiListFilter.used);
                    } else {
                      notifier.setListFilter(YuutaiListFilter.used);
                      context.go('/yuutai?showHistory=true');
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: _searchSectionPaddingH),
          InkWell(
            onTap: () {
              _showSortOptions(context, settings, notifier);
            },
            borderRadius: BorderRadius.circular(_bottomSheetRadius),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.sort_rounded,
                  size: _sortIconSize,
                  color: AppTheme.secondaryTextColor(context),
                ),
                const SizedBox(width: _filterChipSpacing),
                Text(
                  '並び替え：',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: _sortLabelFontSize,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.secondaryTextColor(context),
                      ),
                ),
                Text(
                  _getSortLabel(settings.sortOrder),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: _sortLabelFontSize,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<UsersYuutai> _applyListFilter(
    List<UsersYuutai> items,
    YuutaiListFilter filter,
  ) {
    switch (filter) {
      case YuutaiListFilter.all:
        return items;
      case YuutaiListFilter.expiringSoon:
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);
        return items.where((b) {
          if (b.expiryDate == null) return false;
          final expiryDate = DateTime(
            b.expiryDate!.year,
            b.expiryDate!.month,
            b.expiryDate!.day,
          );
          final diff = expiryDate.difference(todayDate).inDays;
          return diff >= 0 && diff <= _expiringSoonDays;
        }).toList();
      case YuutaiListFilter.active:
        return items.where((b) => b.status == BenefitStatus.active).toList();
      case YuutaiListFilter.used:
        return items.where((b) => b.status == BenefitStatus.used).toList();
    }
  }

  String _getSortLabel(YuutaiSortOrder sortOrder) {
    switch (sortOrder) {
      case YuutaiSortOrder.expiryDate:
        return '期限日';
      case YuutaiSortOrder.companyName:
        return '企業名';
      case YuutaiSortOrder.createdAt:
        return '登録日';
    }
  }

  void _showSortOptions(
    BuildContext context,
    YuutaiListSettings settings,
    YuutaiListSettingsNotifier notifier,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(_bottomSheetRadius)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: _bottomSheetPaddingV),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: _sortOptionPaddingH),
              child: Row(
                children: [
                  Text(
                    '並び替え',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: _sortOptionTitleFontSize,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: _searchSectionPaddingH),
            _SortOption(
              label: '期限日',
              selected: settings.sortOrder == YuutaiSortOrder.expiryDate,
              onTap: () {
                notifier.setSortOrder(YuutaiSortOrder.expiryDate);
                Navigator.pop(context);
              },
            ),
            _SortOption(
              label: '企業名',
              selected: settings.sortOrder == YuutaiSortOrder.companyName,
              onTap: () {
                notifier.setSortOrder(YuutaiSortOrder.companyName);
                Navigator.pop(context);
              },
            ),
            _SortOption(
              label: '登録日',
              selected: settings.sortOrder == YuutaiSortOrder.createdAt,
              onTap: () {
                notifier.setSortOrder(YuutaiSortOrder.createdAt);
                Navigator.pop(context);
              },
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
      padding: const EdgeInsets.fromLTRB(
        _sectionHeaderPaddingL,
        _sectionHeaderPaddingV,
        _sectionHeaderPaddingR,
        12,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: _sortIconSize,
            color: color ?? Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: _filterChipSpacing),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: _sectionHeaderTitleFontSize,
                  fontWeight: FontWeight.bold,
                  color: color ?? Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(UsersYuutai b, [String? stockCode]) {
    return UsersYuutaiListTile(
      benefit: b,
      stockCode: stockCode?.isNotEmpty == true ? stockCode : null,
    );
  }

  Widget _buildSimpleList(
    List<UsersYuutai> items,
    YuutaiListFilter listFilter,
    Map<int, String> stockCodeMap,
  ) {
    return ListView.builder(
      key: ValueKey(listFilter),
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildTile(
        items[index],
        stockCodeMap[items[index].companyId],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                    spreadRadius: -1,
                  ),
                ]
              : [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.08),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 14,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
              ),
        ),
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  const _SortOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: _sortOptionPaddingH,
          vertical: _sortOptionPaddingV,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: _sortOptionLabelFontSize,
                      fontWeight: FontWeight.w500,
                      color: selected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ),
            if (selected)
              Icon(
                Icons.check_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
