import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/folders/providers/folder_providers.dart';

class FolderSelectionPage extends ConsumerWidget {
  const FolderSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(foldersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('フォルダを選択')),
      body: foldersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('エラー: $err')),
        data: (folders) {
          return ListView(
            children: [
              ListTile(
                title: const Text('未分類'),
                onTap: () => Navigator.of(context).pop(null),
              ),
              ...folders.map((folder) {
                return ListTile(
                  title: Text(folder.name),
                  onTap: () => Navigator.of(context).pop(folder.id),
                );
              }),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.add_circle_outline),
                onTap: () async {
                  final id = await _showCreateFolderDialog(context, ref);
                  if (id != null && context.mounted) {
                    Navigator.of(context).pop(id);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  static Future<String?> _showCreateFolderDialog(
      BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'フォルダ名',
              hintText: '例: 食事、旅行',
            ),
            autofocus: true,
            onSubmitted: (value) {
              final trimmed = value.trim();
              if (trimmed.isNotEmpty) Navigator.of(dialogContext).pop(trimmed);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('キャンセル'),
            ),
            FilledButton(
              onPressed: () {
                final trimmed = controller.text.trim();
                if (trimmed.isNotEmpty) {
                  Navigator.of(dialogContext).pop(trimmed);
                }
              },
              child: const Text('作成'),
            ),
          ],
        );
      },
    );
    if (name == null || !context.mounted) return null;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final folder =
          await ref.read(folderRepositoryProvider).createFolder(name);
      return folder.id;
    } catch (e) {
      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('作成に失敗しました: $e')),
        );
      }
      return null;
    }
  }
}

/// シートからポップアップ表示するフォルダ選択用。showModalBottomSheet で表示する。
class FolderSelectionSheetContent extends ConsumerWidget {
  const FolderSelectionSheetContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(foldersProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 12),
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
              child: Text(
                'フォルダを選択',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          Flexible(
            child: foldersAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.all(24),
                child: Center(child: Text('エラー: $err')),
              ),
              data: (folders) {
                return ListView(
                  children: [
                    ListTile(
                      title: const Text('未分類'),
                      onTap: () => Navigator.of(context).pop(null),
                    ),
                    ...folders.map((folder) {
                      return ListTile(
                        title: Text(folder.name),
                        onTap: () => Navigator.of(context).pop(folder.id),
                      );
                    }),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.add_circle_outline),
                      title: const Text('新規フォルダを作成'),
                      onTap: () async {
                        final id =
                            await FolderSelectionPage._showCreateFolderDialog(
                                context, ref);
                        if (id != null && context.mounted) {
                          Navigator.of(context).pop(id);
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
