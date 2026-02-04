import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_stock/core/utils/snackbar_utils.dart';
import 'package:flutter_stock/features/folders/domain/entities/folder.dart';
import 'package:flutter_stock/features/folders/presentation/widgets/rename_folder_dialog.dart';
import 'package:flutter_stock/features/folders/providers/folder_providers.dart';

/// 長押しポップアップ内の1行（アイコン + ラベル）
class DrawerContextMenuItem extends StatelessWidget {
  const DrawerContextMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = destructive ? Colors.red : theme.colorScheme.onSurface;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(width: 14),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// フォルダタイル長押しで表示するコンテキストメニューをオーバーレイで表示する。
void showFolderContextMenu(
  BuildContext tileContext,
  WidgetRef ref,
  Folder folder, {
  required String? selectedFolderId,
  required void Function(String?) onFolderSelected,
}) {
  final box = tileContext.findRenderObject() as RenderBox?;
  if (box == null || !box.hasSize) return;
  final offset = box.localToGlobal(Offset.zero);
  final size = box.size;
  final overlay = Overlay.of(tileContext);
  final screenSize = MediaQuery.sizeOf(tileContext);

  const menuWidth = 220.0;
  const itemHeight = 52.0;
  const padding = 16.0;
  const radius = 20.0;

  double left = offset.dx;
  double top = offset.dy + size.height + 8;
  if (left + menuWidth > screenSize.width - 20) {
    left = screenSize.width - menuWidth - 20;
  }
  if (left < 20) left = 20;
  if (top + (itemHeight * 2) + padding * 2 > screenSize.height - 20) {
    top = offset.dy - (itemHeight * 2) - padding * 2 - 8;
  }
  if (top < 20) top = 20;

  final colorScheme = Theme.of(tileContext).colorScheme;
  late final OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (ctx) => Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => overlayEntry.remove(),
          child: const SizedBox.expand(),
        ),
        Positioned(
          left: left,
          top: top,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Material(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.85,
                ),
                borderRadius: BorderRadius.circular(radius),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  child: SizedBox(
                    width: menuWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DrawerContextMenuItem(
                          icon: Icons.edit_outlined,
                          label: 'フォルダ名の変更',
                          onTap: () {
                            overlayEntry.remove();
                            showDialog(
                              context: tileContext,
                              builder: (dialogCtx) =>
                                  RenameFolderDialog(folder: folder),
                            );
                          },
                        ),
                        DrawerContextMenuItem(
                          icon: Icons.delete_outline,
                          label: '削除',
                          destructive: true,
                          onTap: () async {
                            overlayEntry.remove();
                            final confirmed = await showDialog<bool>(
                              context: tileContext,
                              builder: (dialogCtx) => AlertDialog(
                                title: const Text('フォルダを削除'),
                                content: Text(
                                  '「${folder.name}」を削除しますか？\n中の優待は未分類になります。',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogCtx, false),
                                    child: const Text('キャンセル'),
                                  ),
                                  FilledButton(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () =>
                                        Navigator.pop(dialogCtx, true),
                                    child: const Text('削除'),
                                  ),
                                ],
                              ),
                            );
                            if (confirmed == true && tileContext.mounted) {
                              await _deleteFolder(
                                tileContext,
                                ref,
                                folder,
                                selectedFolderId,
                                onFolderSelected,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
  overlay.insert(overlayEntry);
}

Future<void> _deleteFolder(
  BuildContext context,
  WidgetRef ref,
  Folder folder,
  String? currentSelectedId,
  void Function(String?) onFolderSelected,
) async {
  final folderId = folder.id;
  if (folderId == null) return;
  try {
    await ref.read(folderRepositoryProvider).deleteFolder(folderId);
    if (currentSelectedId == folderId) {
      onFolderSelected(null);
    }
  } catch (e) {
    if (context.mounted) showErrorSnackBar(context, e);
  }
}
