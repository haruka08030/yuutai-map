import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_stock/core/utils/validators.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/core/widgets/loading_elevated_button.dart';

class EmailEditPage extends ConsumerStatefulWidget {
  const EmailEditPage({super.key});

  @override
  ConsumerState<EmailEditPage> createState() => _EmailEditPageState();
}

class _EmailEditPageState extends ConsumerState<EmailEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authRepositoryProvider).currentUser;
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateEmail() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      try {
        final authRepository = ref.read(authRepositoryProvider);
        await authRepository.updateUserEmail(newEmail: _emailController.text);
        ref.invalidate(authRepositoryProvider); // Refresh auth state
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('メールアドレスを更新しました。確認メールをチェックしてください。')),
        );
        context.pop(); // Go back to the previous page
      } catch (e) {
        debugPrint('Failed to update email: $e');
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('更新に失敗しました: ${e.toString()}')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('メールアドレスの編集'), centerTitle: true),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '新しいメールアドレス',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'name@example.com',
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'メールアドレスを入力してください';
                    }
                    if (!emailRegex.hasMatch(value)) {
                      return '有効なメールアドレスを入力してください';
                    }
                    return null;
                  },
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                      ),
                ),
                const SizedBox(height: 24),
                LoadingElevatedButton(
                  onPressed: _updateEmail,
                  isLoading: _isLoading,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'メールアドレスを更新',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
