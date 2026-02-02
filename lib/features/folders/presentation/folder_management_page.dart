import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/core/widgets/app_loading_indicator.dart';
import 'package:flutter_stock/core/widgets/empty_state_view.dart';
import 'package:flutter_stock/features/folders/domain/entities/folder.dart';
import 'package:flutter_stock/features/folders/presentation/widgets/create_folder_dialog.dart';
import 'package:flutter_stock/features/folders/providers/folder_providers.dart';

class FolderManagementPage extends ConsumerWidget {
  const FolderManagementPage({super.key});

  static const routePath = '/folders';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(foldersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('フォルダ管理')),
      body: foldersAsync.when(
        data: (folders) {
          if (folders.isEmpty) {
            return EmptyStateView(
              icon: Icons.folder_open_outlined,
              title: 'フォルダがありません',
              subtitle: '優待を整理するためのフォルダを作成しましょう',
              actionLabel: 'フォルダを作成',
              onActionPressed: () => _showAddFolderDialog(context),
            );
          }
          return ListView.builder(
            itemCount: folders.length,
            itemBuilder: (context, index) {
              final folder = folders[index];
              return ListTile(
                title: Text(folder.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          _showEditFolderDialog(context, ref, folder),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _showDeleteConfirmDialog(context, ref, folder),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const AppLoadingIndicator(),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFolderDialog(context),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddFolderDialog(BuildContext context) {
    CreateFolderDialog.show(context);
  }

  void _showEditFolderDialog(
    BuildContext context,
    WidgetRef ref,
    Folder folder,
  ) {
    final controller = TextEditingController(text: folder.name);
    final folderId = folder.id;
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('フォルダ名を変更'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'フォルダ名'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('キャンセル'),
            ),
            FilledButton(
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isEmpty || folderId == null) return;
                final navigator = Navigator.of(dialogContext);
                final messenger = ScaffoldMessenger.of(context);
                try {
                  await ref.read(folderRepositoryProvider).updateFolder(
                        folderId,
                        name,
                        folder.sortOrder,
                      );
                  if (dialogContext.mounted) {
                    navigator.pop();
                  }
                } catch (e) {
                  if (context.mounted) {
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
      },
    );
  }

  void _showDeleteConfirmDialog(
    BuildContext context,
    WidgetRef ref,
    Folder folder,
  ) {
    final folderId = folder.id;
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('フォルダを削除'),
          content: Text(
            '「${folder.name}」を削除しますか？\n中の優待は未分類になります。',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('キャンセル'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () async {
                if (folderId == null) return;
                final navigator = Navigator.of(dialogContext);
                final messenger = ScaffoldMessenger.of(context);
                try {
                  await ref
                      .read(folderRepositoryProvider)
                      .deleteFolder(folderId);
                  if (dialogContext.mounted) {
                    navigator.pop();
                  }
                } catch (e) {
                  if (context.mounted) {
                    messenger.showSnackBar(
                      SnackBar(content: Text('削除に失敗しました: $e')),
                    );
                  }
                }
              },
              child: const Text('削除'),
            ),
          ],
        );
      },
    );
  }
}
