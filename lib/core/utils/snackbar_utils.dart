import 'package:flutter/material.dart';
import 'package:flutter_stock/core/exceptions/app_exception.dart';

/// エラーを SnackBar で表示する。AppException でメッセージに変換する。
void showErrorSnackBar(BuildContext context, dynamic error) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(AppException.from(error).message)),
  );
}

/// 成功メッセージを SnackBar で表示する。
void showSuccessSnackBar(BuildContext context, String message) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

/// 任意のメッセージを SnackBar で表示する（文言のみ・エラー変換なし）。
void showSnackBarMessage(BuildContext context, String message) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
