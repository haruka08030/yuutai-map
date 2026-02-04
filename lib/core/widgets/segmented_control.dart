import 'package:flutter/material.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';

/// 2択のセグメントコントロール（例: 優待あり / 全店舗）。
/// 選択状態は [selectedIndex] で指定し、[onChanged] で通知する。
class SegmentedControl extends StatelessWidget {
  const SegmentedControl({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  })  : assert(labels.length >= 2),
        assert(selectedIndex >= 0 && selectedIndex < labels.length);

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = AppTheme.dividerColor(context);
    final primary = theme.colorScheme.primary;
    final onPrimary = theme.colorScheme.onPrimary;
    final secondaryText = AppTheme.secondaryTextColor(context);

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: dividerColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final isSelected = index == selectedIndex;
          final isFirst = index == 0;
          final isLast = index == labels.length - 1;
          return Expanded(
            child: Material(
              color: isSelected ? primary : dividerColor,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(isFirst ? 10 : 4),
                right: Radius.circular(isLast ? 10 : 4),
              ),
              child: InkWell(
                onTap: () => onChanged(index),
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(isFirst ? 10 : 4),
                  right: Radius.circular(isLast ? 10 : 4),
                ),
                child: Center(
                  child: Text(
                    labels[index],
                    style: TextStyle(
                      color: isSelected ? onPrimary : secondaryText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
