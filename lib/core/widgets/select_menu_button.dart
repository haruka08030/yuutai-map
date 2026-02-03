import 'package:flutter/material.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';

/// ポップアップメニューで1つ選択するためのアイテム定義。
class SelectMenuItem<T> {
  const SelectMenuItem({
    required this.value,
    required this.label,
  });

  final T value;
  final String label;
}

/// 角丸のコンテナ＋ドロップダウン矢印で、タップでポップアップメニューを表示するボタン。
/// フィルターの「地方」「都道府県」「カテゴリ」などで再利用可能。
class SelectMenuButton<T> extends StatelessWidget {
  const SelectMenuButton({
    super.key,
    required this.value,
    required this.hint,
    required this.items,
    required this.onSelected,
  });

  final T value;
  final String hint;
  final List<SelectMenuItem<T>> items;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final selectedItem = items.firstWhere(
      (item) => item.value == value,
      orElse: () => items.first,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showPopupMenu(context),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.dividerColor(context).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  selectedItem.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight:
                            value == null ? FontWeight.w400 : FontWeight.w500,
                        color: value == null
                            ? AppTheme.secondaryTextColor(context)
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.arrow_drop_down_rounded,
                color: AppTheme.secondaryTextColor(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPopupMenu(BuildContext context) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final T? result = await showMenu<T>(
      context: context,
      position: position,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      constraints: BoxConstraints(
        minWidth: button.size.width,
        maxWidth: button.size.width,
        maxHeight: MediaQuery.sizeOf(context).height * 0.5,
      ),
      items: items.map((item) {
        final isSelected = item.value == value;
        return PopupMenuItem<T>(
          value: item.value,
          height: 48,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_rounded,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        );
      }).toList(),
    );

    if (result != null) {
      onSelected(result);
    }
  }
}
