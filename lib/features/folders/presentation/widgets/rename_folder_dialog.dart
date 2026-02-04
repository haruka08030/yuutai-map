import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_stock/core/utils/snackbar_utils.dart';
import 'package:flutter_stock/features/folders/domain/entities/folder.dart';
import 'package:flutter_stock/features/folders/providers/folder_providers.dart';

/// フォルダ名変更ダイアログ
class RenameFolderDialog extends ConsumerStatefulWidget {
  const RenameFolderDialog({super.key, required this.folder});

  final Folder folder;

  @override
  ConsumerState<RenameFolderDialog> createState() => _RenameFolderDialogState();
}

class _RenameFolderDialogState extends ConsumerState<RenameFolderDialog> {
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
