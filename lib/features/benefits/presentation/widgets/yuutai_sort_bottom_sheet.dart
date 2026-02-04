import 'package:flutter/material.dart';

import 'package:flutter_stock/features/benefits/domain/yuutai_list_settings.dart';
import 'package:flutter_stock/features/benefits/provider/yuutai_list_settings_provider.dart';

const double _bottomSheetRadius = 16;
const double _bottomSheetPaddingV = 24;
const double _sortOptionPaddingH = 24;
const double _sortOptionPaddingV = 16;
const double _sortOptionTitleFontSize = 18;
const double _sortOptionLabelFontSize = 16;
const double _sectionSpacing = 16;

/// 並び替えの表示ラベルを返す
String getSortOrderLabel(YuutaiSortOrder sortOrder) {
  switch (sortOrder) {
    case YuutaiSortOrder.expiryDate:
      return '期限日';
    case YuutaiSortOrder.companyName:
      return '企業名';
    case YuutaiSortOrder.createdAt:
      return '登録日';
  }
}

/// 並び替えボトムシートを表示する
void showYuutaiSortBottomSheet(
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
          const SizedBox(height: _sectionSpacing),
          _SortOptionRow(
            label: '期限日',
            selected: settings.sortOrder == YuutaiSortOrder.expiryDate,
            onTap: () {
              notifier.setSortOrder(YuutaiSortOrder.expiryDate);
              Navigator.pop(context);
            },
          ),
          _SortOptionRow(
            label: '企業名',
            selected: settings.sortOrder == YuutaiSortOrder.companyName,
            onTap: () {
              notifier.setSortOrder(YuutaiSortOrder.companyName);
              Navigator.pop(context);
            },
          ),
          _SortOptionRow(
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

class _SortOptionRow extends StatelessWidget {
  const _SortOptionRow({
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
