import 'package:flutter/material.dart';

import 'package:flutter_stock/features/app/presentation/widgets/drawer/drawer_constants.dart';

/// ドロワー内の1行（アイコン・ラベル・件数・長押し）
class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.iconColor,
    this.count,
    this.onLongPressWithContext,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? iconColor;
  final int? count;
  final void Function(BuildContext tileContext)? onLongPressWithContext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveIconColor = iconColor ?? colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: selected
            ? colorScheme.primaryContainer.withValues(alpha: 0.5)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(kDrawerItemRadius),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPressWithContext != null
              ? () => onLongPressWithContext!(context)
              : null,
          borderRadius: BorderRadius.circular(kDrawerItemRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: selected ? colorScheme.primary : effectiveIconColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                if (count != null && count! > 0)
                  Text(
                    '$count',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
