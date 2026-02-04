import 'package:flutter/material.dart';

import 'package:flutter_stock/features/folders/domain/entities/folder.dart';

import 'package:flutter_stock/features/app/presentation/widgets/drawer/drawer_constants.dart';
import 'package:flutter_stock/features/app/presentation/widgets/drawer/drawer_list_tile.dart';

/// スワイプ削除可能なフォルダ行。ID が null の場合はスワイプ不可。
class DrawerFolderTile extends StatelessWidget {
  const DrawerFolderTile({
    super.key,
    required this.folder,
    required this.selected,
    required this.count,
    required this.theme,
    required this.onTap,
    required this.onDelete,
    this.onLongPress,
  });

  final Folder folder;
  final bool selected;
  final int count;
  final ThemeData theme;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final void Function(BuildContext)? onLongPress;

  @override
  Widget build(BuildContext context) {
    final folderId = folder.id;
    if (folderId == null) {
      return DrawerListTile(
        icon: Icons.folder_outlined,
        iconColor: theme.colorScheme.primary,
        label: folder.name,
        count: count,
        selected: selected,
        onTap: onTap,
        onLongPressWithContext: null,
      );
    }

    return Dismissible(
      key: ValueKey(folderId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(kDrawerItemRadius),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: DrawerListTile(
        icon: Icons.folder_outlined,
        iconColor: theme.colorScheme.primary,
        label: folder.name,
        count: count,
        selected: selected,
        onTap: onTap,
        onLongPressWithContext: onLongPress,
      ),
    );
  }
}
