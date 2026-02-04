import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/app/routing/app_router.dart';
import 'package:flutter_stock/features/benefits/domain/yuutai_list_settings.dart';
import 'package:flutter_stock/features/benefits/provider/yuutai_list_settings_provider.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/features/benefits/provider/yuutai_folder_count_provider.dart';
import 'package:flutter_stock/features/folders/domain/entities/folder.dart';
import 'package:flutter_stock/features/folders/presentation/widgets/create_folder_dialog.dart';
import 'package:flutter_stock/features/folders/providers/folder_providers.dart';
import 'package:flutter_stock/core/utils/snackbar_utils.dart';

/// ドロワー用の角丸・余白
const double _kDrawerItemRadius = 12.0;
const double _kDrawerHorizontalPadding = 16.0;
const double _kDrawerVerticalPadding = 8.0;

class AppDrawer extends ConsumerWidget {
  const AppDrawer({
    super.key,
    required this.selectedFolderId,
    required this.onFolderSelected,
    required this.onMapTapped,
    required this.onSettingsTapped,
    required this.onAllCouponsTapped,
    required this.onHistoryTapped,
  });

  final String? selectedFolderId;
  final Function(String?) onFolderSelected;
  final VoidCallback onMapTapped;
  final VoidCallback onSettingsTapped;
  final VoidCallback onAllCouponsTapped;
  final VoidCallback onHistoryTapped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGuest = ref.watch(isGuestProvider);

    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: isGuest
                  ? _GuestDrawerBody(
                      onSignUp: () {
                        Navigator.of(context).pop();
                        ref.read(routerProvider).go('/signup');
                      },
                      onLogin: () {
                        Navigator.of(context).pop();
                        ref.read(routerProvider).go('/login');
                      },
                    )
                  : _MainDrawerBody(
                      selectedFolderId: selectedFolderId,
                      onFolderSelected: onFolderSelected,
                      onAllCouponsTapped: onAllCouponsTapped,
                      onHistoryTapped: onHistoryTapped,
                    ),
            ),
          ),
          if (!isGuest)
            _DrawerFooter(
              onAddFolderTap: () {
                Navigator.of(context).pop();
                CreateFolderDialog.show(context);
              },
              onSettingsTap: () {
                Navigator.of(context).pop();
                onSettingsTapped();
              },
            ),
        ],
      ),
    );
  }
}

class _GuestDrawerBody extends StatelessWidget {
  const _GuestDrawerBody({
    required this.onSignUp,
    required this.onLogin,
  });

  final VoidCallback onSignUp;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w400,
        );
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: _kDrawerHorizontalPadding,
        vertical: _kDrawerVerticalPadding,
      ),
      children: [
        ListTile(
          leading: const Icon(Icons.person_add_outlined),
          title: Text('新規登録', style: style),
          onTap: onSignUp,
        ),
        ListTile(
          leading: const Icon(Icons.login),
          title: Text('ログイン', style: style),
          onTap: onLogin,
        ),
      ],
    );
  }
}

class _MainDrawerBody extends ConsumerWidget {
  const _MainDrawerBody({
    required this.selectedFolderId,
    required this.onFolderSelected,
    required this.onAllCouponsTapped,
    required this.onHistoryTapped,
  });

  final String? selectedFolderId;
  final Function(String?) onFolderSelected;
  final VoidCallback onAllCouponsTapped;
  final VoidCallback onHistoryTapped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final listFilter = ref.watch(yuutaiListSettingsProvider).listFilter;
    final foldersAsync = ref.watch(foldersProvider);
    final yuutaiCounts = ref.watch(yuutaiCountPerFolderProvider);
    final activeCountAsync = ref.watch(activeUsersYuutaiProvider);
    final historyCountAsync = ref.watch(historyUsersYuutaiProvider);

    final activeCount = activeCountAsync.whenOrNull(data: (l) => l.length) ?? 0;
    final historyCount =
        historyCountAsync.whenOrNull(data: (l) => l.length) ?? 0;
    final isAllSelected =
        selectedFolderId == null && listFilter != YuutaiListFilter.used;
    final isHistorySelected = listFilter == YuutaiListFilter.used;

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: _kDrawerHorizontalPadding,
        vertical: _kDrawerVerticalPadding,
      ),
      children: [
        _DrawerListTile(
          icon: Icons.view_list_outlined,
          iconColor: theme.colorScheme.primary,
          label: 'すべて',
          count: activeCount,
          selected: isAllSelected,
          onTap: onAllCouponsTapped,
        ),
        foldersAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (folders) {
            return Column(
              children: [
                ...folders.map(
                  (folder) => _DismissibleFolderTile(
                    folder: folder,
                    selected: selectedFolderId == folder.id,
                    count: yuutaiCounts[folder.id] ?? 0,
                    theme: theme,
                    onTap: () => onFolderSelected(folder.id),
                    onDelete: () => _deleteFolder(
                      context,
                      ref,
                      folder,
                      selectedFolderId,
                      onFolderSelected,
                    ),
                    onLongPress: folder.id != null
                        ? (ctx) => _showFolderContextMenu(ctx, ref, folder)
                        : null,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        _DrawerListTile(
          icon: Icons.history,
          iconColor: AppTheme.secondaryTextColor(context),
          label: '使用済み',
          count: historyCount,
          selected: isHistorySelected,
          onTap: onHistoryTapped,
        ),
      ],
    );
  }

  Future<void> _deleteFolder(
    BuildContext context,
    WidgetRef ref,
    Folder folder,
    String? currentSelectedId,
    Function(String?) onFolderSelected,
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

  void _showFolderContextMenu(
    BuildContext tileContext,
    WidgetRef ref,
    Folder folder,
  ) {
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
                          _ContextMenuItem(
                            icon: Icons.edit_outlined,
                            label: 'フォルダ名の変更',
                            onTap: () {
                              overlayEntry.remove();
                              _showRenameFolderDialog(tileContext, ref, folder);
                            },
                          ),
                          _ContextMenuItem(
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
                                _deleteFolder(
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

  void _showRenameFolderDialog(
      BuildContext context, WidgetRef ref, Folder folder) {
    showDialog(
      context: context,
      builder: (ctx) => _RenameFolderDialog(folder: folder),
    );
  }
}

class _DismissibleFolderTile extends StatelessWidget {
  const _DismissibleFolderTile({
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
      return _DrawerListTile(
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
          borderRadius: BorderRadius.circular(_kDrawerItemRadius),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: _DrawerListTile(
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

/// 長押しポップアップ内の1行（アイコン + ラベル）
class _ContextMenuItem extends StatelessWidget {
  const _ContextMenuItem({
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

class _DrawerListTile extends StatelessWidget {
  const _DrawerListTile({
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

    final Widget content = Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: selected
            ? colorScheme.primaryContainer.withValues(alpha: 0.5)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(_kDrawerItemRadius),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPressWithContext != null
              ? () => onLongPressWithContext!(context)
              : null,
          borderRadius: BorderRadius.circular(_kDrawerItemRadius),
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
    return content;
  }
}

class _DrawerFooter extends StatelessWidget {
  const _DrawerFooter({
    required this.onAddFolderTap,
    required this.onSettingsTap,
  });

  final VoidCallback onAddFolderTap;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.only(
        left: _kDrawerHorizontalPadding,
        right: _kDrawerHorizontalPadding,
        bottom: MediaQuery.of(context).padding.bottom + 8,
        top: 8,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.extension<AppColors>()?.divider ??
                colorScheme.outlineVariant,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            TextButton.icon(
              onPressed: onAddFolderTap,
              icon: Icon(
                Icons.create_new_folder_outlined,
                size: 20,
                color: colorScheme.primary,
              ),
              label: Text(
                'フォルダを追加',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: colorScheme.primary,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: colorScheme.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RenameFolderDialog extends ConsumerStatefulWidget {
  const _RenameFolderDialog({required this.folder});
  final Folder folder;

  @override
  ConsumerState<_RenameFolderDialog> createState() =>
      _RenameFolderDialogState();
}

class _RenameFolderDialogState extends ConsumerState<_RenameFolderDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.folder.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('フォルダ名を変更'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(labelText: 'フォルダ名'),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('キャンセル'),
        ),
        FilledButton(
          onPressed: () async {
            if (_controller.text.trim().isEmpty) return;
            final folderId = widget.folder.id;
            final navigator = Navigator.of(context);
            final scaffoldContext = context;
            if (folderId == null) {
              showSnackBarMessage(context, 'フォルダIDが不正です');
              return;
            }
            try {
              await ref.read(folderRepositoryProvider).updateFolder(
                    folderId,
                    _controller.text.trim(),
                    widget.folder.sortOrder,
                  );
              if (mounted) navigator.pop();
            } catch (e) {
              if (mounted) {
                // ignore: use_build_context_synchronously - context captured before async
                showErrorSnackBar(scaffoldContext, e);
              }
            }
          },
          child: const Text('保存'),
        ),
      ],
    );
  }
}
