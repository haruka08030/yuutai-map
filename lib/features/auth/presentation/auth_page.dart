import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/core/utils/snackbar_utils.dart';
import 'package:flutter_stock/core/utils/validators.dart';
import 'package:flutter_stock/core/widgets/loading_elevated_button.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/features/auth/presentation/widgets/auth_dialogs.dart';
import 'package:flutter_stock/features/auth/presentation/widgets/login_form_widgets.dart';
import 'package:flutter_stock/features/auth/presentation/widgets/password_strength_indicator.dart';

// レイアウト定数
const double _contentMaxWidth = 420;
const double _contentPaddingH = 32;
const double _contentPaddingV = 48;
const double _iconSize = 64;
const double _titleFontSize = 28;
const double _subtitleFontSize = 15;
const double _linkFontSize = 13;
const double _spacingAfterIcon = 24;
const double _spacingAfterTitle = 8;
const double _spacingBeforeForm = 48;
const double _fieldSpacing = 16;
const double _spacingBeforePrimaryButton = 24;
const double _spacingBeforeDivider = 32;
const double _spacingBeforeGuest = 48;
const double _spacingAfterModePrompt = 16;

/// ログイン・新規登録を1画面で切り替える認証ページ。
/// [isSignUp] が true のとき新規登録フォーム、false のときログインフォームを表示する。
class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key, required this.isSignUp});

  final bool isSignUp;

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _password = '';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await ref.read(authRepositoryProvider).signInWithEmailPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );
      } on AuthException catch (e) {
        if (!mounted) return;
        showErrorSnackBar(context, e);
      } catch (e) {
        if (!mounted) return;
        showErrorSnackBar(context, e);
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signUpWithEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await ref.read(authRepositoryProvider).signUpWithEmailPassword(
              username: _nameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );
        if (mounted) {
          showSuccessSnackBar(context, '確認メールを送信しました。メールを確認してください。');
          context.go('/login');
        }
      } on AuthException catch (e) {
        if (mounted) showErrorSnackBar(context, e);
      } catch (e) {
        if (mounted) showErrorSnackBar(context, e);
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
    } on AuthException catch (e) {
      if (!mounted) return;
      showErrorSnackBar(context, e);
    } catch (e) {
      if (!mounted) return;
      showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithApple() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).signInWithApple();
    } on AuthException catch (e) {
      if (!mounted) return;
      showErrorSnackBar(context, e);
    } catch (e) {
      if (!mounted) return;
      showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _signInAsGuest() {
    ref.read(authRepositoryProvider).signInAsGuest();
    if (mounted) context.go('/yuutai');
  }

  @override
  Widget build(BuildContext context) {
    final isSignUp = widget.isSignUp;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(
                horizontal: _contentPaddingH,
                vertical: _contentPaddingV,
              ),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      isSignUp
                          ? Icons.person_add_outlined
                          : Icons.account_balance_wallet_outlined,
                      size: _iconSize,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: _spacingAfterIcon),
                    Text(
                      isSignUp ? '新規登録' : 'おかえりなさい',
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                fontSize: _titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                    ),
                    const SizedBox(height: _spacingAfterTitle),
                    Text(
                      isSignUp ? 'アカウントを作成して優待管理を始めましょう' : '続行するにはログインしてください',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: _subtitleFontSize,
                        color: AppTheme.secondaryTextColor(context),
                      ),
                    ),
                    const SizedBox(height: _spacingBeforeForm),
                    if (isSignUp) ...[
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'アカウント名',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        autofillHints: const [AutofillHints.username],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'アカウント名を入力してください';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: _fieldSpacing),
                    ],
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'メールアドレス',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
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
                    const SizedBox(height: _fieldSpacing),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'パスワード',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                      autofillHints: isSignUp
                          ? const [AutofillHints.newPassword]
                          : const [AutofillHints.password],
                      onChanged: isSignUp
                          ? (value) => setState(() => _password = value)
                          : null,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'パスワードを入力してください';
                        }
                        if (isSignUp && value.length < 6) {
                          return 'パスワードは6文字以上で入力してください';
                        }
                        return null;
                      },
                    ),
                    if (isSignUp) ...[
                      const SizedBox(height: 12),
                      PasswordStrengthIndicator(password: _password),
                    ] else
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _isLoading
                              ? null
                              : () => showForgotPasswordDialog(context, ref),
                          child: const Text(
                            'パスワードを忘れましたか？',
                            style: TextStyle(
                              fontSize: _linkFontSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: _spacingBeforePrimaryButton),
                    if (isSignUp)
                      LoadingElevatedButton(
                        onPressed: _signUpWithEmail,
                        isLoading: _isLoading,
                        child: const Text('登録する'),
                      )
                    else
                      LoadingElevatedButton(
                        onPressed: _signInWithEmail,
                        isLoading: _isLoading,
                        child: const Text('ログイン'),
                      ),
                    const SizedBox(height: _spacingBeforeDivider),
                    const OrDivider(),
                    const SizedBox(height: _spacingBeforeDivider),
                    SocialSignInButtons(
                      isLoading: _isLoading,
                      onSignInWithGoogle: _signInWithGoogle,
                      onSignInWithApple: _signInWithApple,
                      googleLabel: isSignUp ? 'Googleで登録' : 'Googleでサインイン',
                      appleLabel: isSignUp ? 'Appleで登録' : 'Appleでサインイン',
                    ),
                    if (!isSignUp) ...[
                      const SizedBox(height: _spacingBeforeGuest),
                      SignUpPrompt(isLoading: _isLoading),
                      const SizedBox(height: _spacingAfterModePrompt),
                      TextButton(
                        onPressed: _isLoading ? null : _signInAsGuest,
                        child: const Text('ゲストとして利用'),
                      ),
                    ] else ...[
                      const SizedBox(height: _spacingBeforeGuest),
                      LoginPrompt(isLoading: _isLoading),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
