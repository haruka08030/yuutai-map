import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/folders/domain/entities/folder.dart';
import 'package:flutter_stock/features/folders/providers/folder_providers.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';

class FoldersSection extends ConsumerWidget {
  const FoldersSection({
    super.key,
    required this.selectedFolderId,
    required this.onFolderSelected,
  });

  final String? selectedFolderId;
  final Function(String?) onFolderSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(foldersProvider);
    final isGuest = ref.watch(isGuestProvider); // Watch guest status

    return foldersAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (err, _) {
        debugPrint('Failed to load folders: $err');
        return const SizedBox.shrink();
      },
      data: (folders) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'フォルダ',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 20),
                    onPressed: isGuest ? null : () => _showCreateFolderDialog(context),
                  ),
                ],
              ),
            ),
            ...folders.map(
              (folder) => ListTile(
                leading: const Icon(Icons.folder),
                title: Text(folder.name),
                selected: selectedFolderId == folder.id,
                onTap: isGuest ? null : () => onFolderSelected(folder.id),
                trailing: isGuest
                    ? null // Disable trailing icon for guests
                    : IconButton(
                        icon: const Icon(Icons.more_vert, size: 20),
                        onPressed: () => _showFolderOptions(context, ref, folder),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCreateFolderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => const _CreateFolderDialog(),
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
              leading: const Icon(Icons.edit),
              title: const Text('名前を変更'),
              onTap: () {
                Navigator.pop(ctx);
                _showRenameFolderDialog(context, folder);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('削除', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(ctx);
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('フォルダを削除'),
                    content: Text('「${folder.name}」を削除しますか？\n中の優待は未分類になります。'),
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
                if (confirmed == true) {
                  final folderId = folder.id;
                  if (folderId == null) return;
                  try {
                    await ref
                        .read(folderRepositoryProvider)
                        .deleteFolder(folderId);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('削除に失敗しました: $e')));
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
    BuildContext context,
    Folder folder,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => _RenameFolderDialog(folder: folder),
    );
  }
}

class _CreateFolderDialog extends ConsumerStatefulWidget {
  const _CreateFolderDialog();

  @override
  ConsumerState<_CreateFolderDialog> createState() => _CreateFolderDialogState();
}

class _CreateFolderDialogState extends ConsumerState<_CreateFolderDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('新しいフォルダ'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'フォルダ名',
          hintText: '例: 食事、旅行',
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('キャンセル'),
        ),
        FilledButton(
          onPressed: () async {
            if (_controller.text.trim().isNotEmpty) {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              try {
                await ref
                    .read(folderRepositoryProvider)
                    .createFolder(_controller.text.trim());

                if (mounted) {
                  navigator.pop();
                }
              } catch (e) {
                if (mounted) {
                  messenger.showSnackBar(
                    SnackBar(content: Text('作成に失敗しました: $e')),
                  );
                }
              }
            }
          },
          child: const Text('作成'),
        ),
      ],
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
            if (_controller.text.trim().isNotEmpty) {
              final folderId = widget.folder.id;
              if (folderId == null) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('フォルダIDが不正です')),
                  );
                }
                return;
              }
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              try {
                await ref.read(folderRepositoryProvider).updateFolder(
                      folderId,
                      _controller.text.trim(),
                      widget.folder.sortOrder,
                    );
                if (mounted) {
                  navigator.pop();
                }
              } catch (e) {
                if (mounted) {
                  messenger.showSnackBar(
                    SnackBar(content: Text('更新に失敗しました: $e')),
                  );
                }
              }
            }
          },
          child: const Text('保存'),
        ),
      ],
    );
  }
}