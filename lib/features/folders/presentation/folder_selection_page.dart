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
            ],
          );
        },
      ),
    );
  }
}
