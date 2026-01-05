import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/app/theme/theme_provider.dart';
import 'package:flutter_stock/app/widgets/app_loading_indicator.dart';
import 'package:flutter_stock/features/folders/presentation/folder_management_page.dart';
import 'package:url_launcher/url_launcher.dart'; // Add url_launcher

const String _privacyPolicyUrl = 'https://your-privacy-policy-url.com'; // TODO: Update with actual URL

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
                context.push('/login');
              },
              child: const Text('ログイン'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context.push('/signup');
              },
              child: const Text('新規登録'),
            ),
            const SizedBox(height: 24), // Add spacing for privacy policy
            // Privacy Policy button for guest users
            TextButton(
              onPressed: () async {
                if (!await launchUrl(Uri.parse(_privacyPolicyUrl))) {
                  // Handle error if URL cannot be launched
                }
              },
              child: const Text('プライバシーポリシー'),
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
            ListTile(
              title: const Text('フォルダ管理'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.push(FolderManagementPage.routePath);
              },
            ),
            SwitchListTile(
              title: const Text('ダークモード'),
              value: themeMode == ThemeMode.dark,
              onChanged: (isOn) {
                ref
                    .read(themeProvider.notifier)
                    .setThemeMode(isOn ? ThemeMode.dark : ThemeMode.light);
              },
            ),
            // Add Privacy Policy button here
            ListTile(
              title: const Text('プライバシーポリシー'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                if (!await launchUrl(Uri.parse(_privacyPolicyUrl))) {
                  // Handle error if URL cannot be launched
                }
              },
            ),
            const SizedBox(height: 24), // Add spacing
            ElevatedButton(
              onPressed: () async {
                await ref.read(authRepositoryProvider).signOut();
              },
              child: const Text('ログアウト'),
            ),
            const SizedBox(height: 32),
            TextButton(
              onPressed: () => _showDeleteConfirmation(context, ref),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('アカウントを完全に削除する'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('アカウント削除の確認'),
        content: const Text('アカウントを削除すると、登録されたすべての優待データやフォルダが完全に削除されます。この操作は取り消せません。本当に削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('削除する'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(authRepositoryProvider).deleteAccount();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('アカウントを削除しました')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('削除に失敗しました: $e')),
          );
        }
      }
    }
  }
}