
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/features/auth/presentation/login_page.dart';
import 'package:flutter_stock/features/auth/presentation/signup_page.dart';
import 'package:flutter_stock/app/theme/theme_provider.dart'; // New import
import 'package:flutter_stock/app/widgets/app_loading_indicator.dart'; // New Import

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGuest = ref.watch(isGuestProvider);
    final user = ref.watch(authRepositoryProvider).currentUser;

    return Scaffold(
      body: isGuest
          ? const AuthOptionsPage()
          : user != null
              ? AccountInfoPage(user: user)
              : const AppLoadingIndicator(),
    );
  }
}

class AuthOptionsPage extends StatelessWidget {
  const AuthOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox( // New
        constraints: const BoxConstraints(maxWidth: 600.0), // New
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('ログイン'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              child: const Text('新規登録'),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountInfoPage extends ConsumerWidget {
  const AccountInfoPage({super.key, required this.user});

  final dynamic user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider); // Watch current theme
    return Center(
      child: ConstrainedBox( // New
        constraints: const BoxConstraints(maxWidth: 600.0), // New
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('メールアドレス: ${user.email}'),
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text('ダークモード'),
              value: themeMode == ThemeMode.dark,
              onChanged: (isOn) {
                ref.read(themeProvider.notifier).setThemeMode(isOn ? ThemeMode.dark : ThemeMode.light);
              },
            ),
            const SizedBox(height: 24), // Add spacing
            ElevatedButton(
              onPressed: () async {
                await ref.read(authRepositoryProvider).signOut();
              },
              child: const Text('ログアウト'),
            ),
          ],
        ),
      ),
    );
  }
}
