import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/features/benefits/domain/yuutai_list_settings.dart';
import 'package:flutter_stock/features/benefits/presentation/widgets/yuutai_sort_bottom_sheet.dart';
import 'package:flutter_stock/features/benefits/provider/yuutai_list_settings_provider.dart';

const double _filterChipSpacing = 8;
const double _searchSectionPaddingH = 16;
const double _searchSectionPaddingV = 12;
const double _sortIconSize = 18;
const double _sortLabelFontSize = 14;
const double _bottomSheetRadius = 8;

/// 優待一覧のフィルターチップ＋並び替え行
class YuutaiFilterBar extends StatelessWidget {
  const YuutaiFilterBar({
    super.key,
    required this.settings,
    required this.notifier,
    required this.showHistory,
  });

  final YuutaiListSettings settings;
  final YuutaiListSettingsNotifier notifier;
  final bool showHistory;

  @override
  Widget build(BuildContext context) {
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
                YuutaiFilterChip(
                  label: 'すべて',
                  selected: !showHistory &&
                      settings.listFilter == YuutaiListFilter.all,
                  onTap: () {
                    notifier.setListFilter(YuutaiListFilter.all);
                    if (showHistory) {
                      context.go('/yuutai');
                    }
                  },
                ),
                const SizedBox(width: _filterChipSpacing),
                YuutaiFilterChip(
                  label: '期限間近',
                  selected:
                      settings.listFilter == YuutaiListFilter.expiringSoon,
                  onTap: () =>
                      notifier.setListFilter(YuutaiListFilter.expiringSoon),
                ),
                const SizedBox(width: _filterChipSpacing),
                YuutaiFilterChip(
                  label: '有効',
                  selected: settings.listFilter == YuutaiListFilter.active,
                  onTap: () => notifier.setListFilter(YuutaiListFilter.active),
                ),
                const SizedBox(width: _filterChipSpacing),
                YuutaiFilterChip(
                  label: '使用済み',
                  selected: settings.listFilter == YuutaiListFilter.used,
                  onTap: () {
                    notifier.setListFilter(YuutaiListFilter.used);
                    if (!showHistory) {
                      context.go('/yuutai?showHistory=true');
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: _searchSectionPaddingH),
          InkWell(
            onTap: () => showYuutaiSortBottomSheet(context, settings, notifier),
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
                  getSortOrderLabel(settings.sortOrder),
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
}

/// フィルターチップ1つ
class YuutaiFilterChip extends StatelessWidget {
  const YuutaiFilterChip({
    super.key,
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
