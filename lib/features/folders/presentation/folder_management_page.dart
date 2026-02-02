import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/core/widgets/app_loading_indicator.dart';
import 'package:flutter_stock/core/widgets/empty_state_view.dart';
import 'package:flutter_stock/features/folders/domain/entities/folder.dart';
import 'package:flutter_stock/features/folders/providers/folder_providers.dart';

class FolderManagementPage extends ConsumerWidget {
  const FolderManagementPage({super.key});

  static const routePath = '/folders';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(foldersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Folder Management')),
      body: foldersAsync.when(
        data: (folders) {
          if (folders.isEmpty) {
            return EmptyStateView(
              icon: Icons.folder_open_outlined,
              title: 'フォルダがありません',
              subtitle: '優待を整理するためのフォルダを作成しましょう',
              actionLabel: 'フォルダを作成',
              onActionPressed: () => _showAddFolderDialog(context, ref),
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
        onPressed: () => _showAddFolderDialog(context, ref),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddFolderDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Folder'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Folder Name'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  ref
                      .read(folderRepositoryProvider)
                      .createFolder(controller.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditFolderDialog(
    BuildContext context,
    WidgetRef ref,
    Folder folder,
  ) {
    final controller = TextEditingController(text: folder.name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Folder'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Folder Name'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  ref.read(folderRepositoryProvider).updateFolder(
                        folder.id!,
                        controller.text,
                        folder.sortOrder,
                      );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Folder'),
          content: Text('Are you sure you want to delete "${folder.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ref.read(folderRepositoryProvider).deleteFolder(folder.id!);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
