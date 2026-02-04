import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/core/exceptions/app_exception.dart';
import 'package:flutter_stock/core/widgets/app_error_view.dart';
import 'package:flutter_stock/core/widgets/empty_state_view.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/features/benefits/domain/entities/benefit_status.dart';
import 'package:flutter_stock/features/benefits/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/features/benefits/domain/yuutai_list_settings.dart';
import 'package:flutter_stock/features/benefits/presentation/widgets/add_yuutai_sheet.dart';
import 'package:flutter_stock/features/benefits/presentation/widgets/yuutai_filter_bar.dart';
import 'package:flutter_stock/features/benefits/provider/company_provider.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/features/benefits/provider/yuutai_list_settings_provider.dart';
import 'package:flutter_stock/features/benefits/presentation/widgets/users_yuutai_list_tile.dart';
import 'package:flutter_stock/features/benefits/presentation/widgets/users_yuutai_skeleton_tile.dart';

// リスト・UI定数
const int _skeletonItemCount = 8;
const double _errorViewHeightOffset = 200;
const double _listPaddingVertical = 8;
const double _sectionSpacing = 24;
const double _expiringSoonDays = 30;
const double _filterChipSpacing = 8;
const double _sortIconSize = 18;
const double _sectionHeaderPaddingL = 20;
const double _sectionHeaderPaddingR = 16;
const double _sectionHeaderPaddingV = 16;
const double _sectionHeaderTitleFontSize = 15;
const double _fabIconSize = 28;

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
          YuutaiFilterBar(
            settings: settings,
            notifier: settingsNotifier,
            showHistory: widget.showHistory,
          ),
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
