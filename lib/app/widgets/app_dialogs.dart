import 'package:flutter/material.dart';

/// Displays a generic confirmation dialog.
/// Returns true if confirmed, false if cancelled.
Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmButtonText = '削除',
  Color? confirmButtonColor,
}) async {
  return await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('キャンセル'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: confirmButtonColor ?? Colors.red,
          ),
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(confirmButtonText),
        ),
      ],
    ),
  );
}
