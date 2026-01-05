import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // New import
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/core/exceptions/app_exception.dart';
import 'package:flutter_stock/core/utils/validators.dart';

/// Displays a dialog to reset the user's password.
/// Requires [context] for displaying the dialog and [ref] for accessing AuthRepository.
Future<void> showForgotPasswordDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  final emailController = TextEditingController();
  await showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('パスワードをリセット'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('登録したメールアドレスを入力してください。パスワードリセット用のメールを送信します。'),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'メールアドレスを入力してください';
                }
                if (!emailRegex.hasMatch(value)) {
                  return '有効なメールアドレスを入力してください';
                }
                return null;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = emailController.text.trim();
              if (email.isEmpty) {
                return;
              }
              // Capture context before async gap for mounted check
              final currentDialogContext = dialogContext;
              final scaffoldMessenger = ScaffoldMessenger.of(
                currentDialogContext,
              );
              final navigator = Navigator.of(currentDialogContext);

              try {
                await ref
                    .read(authRepositoryProvider)
                    .resetPasswordForEmail(email: email);
                if (!currentDialogContext.mounted) return;
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('パスワードリセット用のメールを送信しました。')),
                );
                navigator.pop();
              } on AuthException catch (e) {
                if (!currentDialogContext.mounted) return;
                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text(AppException.from(e).message)),
                );
              } catch (e) {
                if (!currentDialogContext.mounted) return;
                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text(AppException.from(e).message)),
                );
              }
            },
            child: const Text('送信'),
          ),
        ],
      );
    },
  );
}
