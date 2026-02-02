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
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: _kDrawerHorizontalPadding,
        vertical: _kDrawerVerticalPadding,
      ),
      children: [
        ListTile(
          leading: const Icon(Icons.person_add_outlined),
          title: const Text('新規登録'),
          onTap: onSignUp,
        ),
        ListTile(
          leading: const Icon(Icons.login),
          title: const Text('ログイン'),
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
          icon: Icons.folder_outlined,
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
                  (folder) => _DrawerListTile(
                    icon: Icons.folder_outlined,
                    iconColor: theme.colorScheme.primary,
                    label: folder.name,
                    count: yuutaiCounts[folder.id] ?? 0,
                    selected: selectedFolderId == folder.id,
                    onTap: () => onFolderSelected(folder.id),
                    onLongPress: folder.id != null
                        ? () => _showFolderOptions(context, ref, folder)
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

  void _showFolderOptions(BuildContext context, WidgetRef ref, Folder folder) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('名前を変更'),
              onTap: () {
                Navigator.pop(ctx);
                _showRenameFolderDialog(context, ref, folder);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('削除', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(ctx);
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('フォルダを削除'),
                    content: Text(
                      '「${folder.name}」を削除しますか？\n中の優待は未分類になります。',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('キャンセル'),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('削除'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true && context.mounted) {
                  final folderId = folder.id;
                  if (folderId != null) {
                    try {
                      await ref
                          .read(folderRepositoryProvider)
                          .deleteFolder(folderId);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('削除に失敗しました: $e')),
                        );
                      }
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRenameFolderDialog(
      BuildContext context, WidgetRef ref, Folder folder) {
    showDialog(
      context: context,
      builder: (ctx) => _RenameFolderDialog(folder: folder),
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
    this.onLongPress,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? iconColor;
  final int? count;
  final VoidCallback? onLongPress;

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
        borderRadius: BorderRadius.circular(_kDrawerItemRadius),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
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
            FilledButton.icon(
              onPressed: onAddFolderTap,
              icon: const Icon(Icons.create_new_folder_outlined, size: 20),
              label: const Text('フォルダを追加'),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_kDrawerItemRadius),
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: onSettingsTap,
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
            final messenger = ScaffoldMessenger.of(context);
            if (folderId == null) {
              messenger.showSnackBar(
                const SnackBar(content: Text('フォルダIDが不正です')),
              );
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
                messenger.showSnackBar(
                  SnackBar(content: Text('更新に失敗しました: $e')),
                );
              }
            }
          },
          child: const Text('保存'),
        ),
      ],
    );
  }
}
