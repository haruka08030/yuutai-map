import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/core/utils/snackbar_utils.dart';
import 'package:flutter_stock/core/utils/validators.dart';

/// Displays a dialog to reset the user's password.
/// Requires [context] for displaying the dialog and [ref] for accessing AuthRepository.
Future<void> showForgotPasswordDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  await showDialog(
    context: context,
    builder: (dialogContext) {
      return _ForgotPasswordDialog(ref: ref);
    },
  );
}

class _ForgotPasswordDialog extends StatefulWidget {
  const _ForgotPasswordDialog({required this.ref});

  final WidgetRef ref;

  @override
  State<_ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<_ForgotPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    final email = _emailController.text.trim();
    final navigator = Navigator.of(context);

    try {
      await widget.ref
          .read(authRepositoryProvider)
          .resetPasswordForEmail(email: email);
      if (!mounted) return;
      showSuccessSnackBar(context, 'パスワードリセット用のメールを送信しました。');
      navigator.pop();
    } on AuthException catch (e) {
      if (!mounted) return;
      showErrorSnackBar(context, e);
    } catch (e) {
      if (!mounted) return;
      showErrorSnackBar(context, e);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('パスワードをリセット'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('登録したメールアドレスを入力してください。パスワードリセット用のメールを送信します。'),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              enabled: !_isLoading,
              autofocus: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'メールアドレスを入力してください';
                }
                if (!emailRegex.hasMatch(value.trim())) {
                  return '有効なメールアドレスを入力してください';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSubmit,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('送信'),
        ),
      ],
    );
  }
}
