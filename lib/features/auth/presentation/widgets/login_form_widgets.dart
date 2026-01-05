import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppTheme.dividerColor(context))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'または',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.secondaryTextColor(context),
            ),
          ),
        ),
        Expanded(child: Divider(color: AppTheme.dividerColor(context))),
      ],
    );
  }
}

class SignUpPrompt extends StatelessWidget {
  const SignUpPrompt({super.key, required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'アカウントをお持ちでないですか？',
          style: TextStyle(color: AppTheme.secondaryTextColor(context)),
        ),
        TextButton(
          onPressed: isLoading ? null : () => context.go('/signup'),
          child: const Text(
            '新規登録',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class SocialSignInButtons extends StatelessWidget {
  const SocialSignInButtons({
    super.key,
    required this.isLoading,
    required this.onSignInWithGoogle,
    required this.onSignInWithApple,
  });

  final bool isLoading;
  final VoidCallback onSignInWithGoogle;
  final VoidCallback onSignInWithApple;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: isLoading ? null : onSignInWithGoogle,
          icon: const Icon(Icons.g_mobiledata, size: 28),
          label: const Text('Googleでサインイン'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(
              context,
            ).extension<AppColors>()?.googleButtonBackground,
            foregroundColor: Theme.of(
              context,
            ).extension<AppColors>()?.googleButtonForeground,
            side: BorderSide(color: AppTheme.dividerColor(context)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            ),
          ),
        ),
        if (!kIsWeb &&
            (defaultTargetPlatform == TargetPlatform.iOS ||
                defaultTargetPlatform == TargetPlatform.macOS)) ...[
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: isLoading ? null : onSignInWithApple,
            icon: const Icon(Icons.apple, size: 20),
            label: const Text('Appleでサインイン'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(
                context,
              ).extension<AppColors>()?.appleButtonBackground,
              foregroundColor: Theme.of(
                context,
              ).extension<AppColors>()?.appleButtonForeground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
