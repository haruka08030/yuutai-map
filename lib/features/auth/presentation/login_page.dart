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
const double _spacingBeforeLoginButton = 24;
const double _spacingBeforeDivider = 32;
const double _spacingBeforeGuest = 48;
const double _spacingAfterSignUpPrompt = 16;

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
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
        // The AuthGate will handle navigation if successful
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
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInAsGuest() async {
    ref.read(authRepositoryProvider).signInAsGuest();
    if (mounted) {
      context.go('/yuutai');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      Icons.account_balance_wallet_outlined,
                      size: _iconSize,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: _spacingAfterIcon),
                    Text(
                      'おかえりなさい',
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
                      '続行するにはログインしてください',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: _subtitleFontSize,
                        color: AppTheme.secondaryTextColor(context),
                      ),
                    ),
                    const SizedBox(height: _spacingBeforeForm),
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
                      autofillHints: const [AutofillHints.password],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'パスワードを入力してください';
                        }
                        return null;
                      },
                    ),
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
                    const SizedBox(height: _spacingBeforeLoginButton),
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
                    ),
                    const SizedBox(height: _spacingBeforeGuest),
                    SignUpPrompt(isLoading: _isLoading),
                    const SizedBox(height: _spacingAfterSignUpPrompt),
                    TextButton(
                      onPressed: _isLoading ? null : _signInAsGuest,
                      child: const Text('ゲストとして利用'),
                    ),
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
