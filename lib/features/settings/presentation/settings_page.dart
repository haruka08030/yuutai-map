import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/app/theme/theme_provider.dart';
import 'package:flutter_stock/app/widgets/app_loading_indicator.dart';
import 'package:url_launcher/url_launcher.dart'; // Add url_launcher

const String _privacyPolicyUrl = 'https://your-privacy-policy-url.com'; // TODO: Update with actual URL

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGuest = ref.watch(isGuestProvider);
    final user = ref.watch(authRepositoryProvider).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
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
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              const SizedBox(height: 32),
              // Guest Section
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFC4C4C4),
                        shape: OvalBorder(),
                      ),
                      child: const Icon(Icons.person_outline, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'ゲストユーザー',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Figtree',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'ログインして全ての機能を利用しましょう',
                      style: TextStyle(
                        color: Color(0xFF767E8C),
                        fontSize: 14,
                        fontFamily: 'Figtree',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => context.push('/login'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF24A19C),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('ログイン'),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: () => context.push('/signup'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF24A19C)),
                            foregroundColor: const Color(0xFF24A19C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('新規登録'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              // Menu Items (Common for Guest/User if applicable)
              _SettingsTile(
                icon: Icons.lock_outline,
                label: 'プライバシーポリシー',
                onTap: () async {
                  if (!await launchUrl(Uri.parse(_privacyPolicyUrl))) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('プライバシーポリシーを開けませんでした')),
                      );
                    }
                  }
                },
              ),
              _SettingsTile(
                icon: Icons.info_outline,
                label: 'ライセンス表記',
                onTap: () => showLicensePage(context: context),
              ),
              const SizedBox(height: 48),
              // Footer
              const Center(
                child: Column(
                  children: [
                    Text(
                      'App Version 1.0.0',
                      style: TextStyle(
                        color: Color(0xFF767E8C),
                        fontSize: 12,
                        fontFamily: 'Figtree',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }
}

class AccountInfoPage extends ConsumerWidget {
  const AccountInfoPage({super.key, required this.user});

  final dynamic user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              const SizedBox(height: 32),
              // Profile Section
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFC4C4C4),
                        shape: OvalBorder(),
                      ),
                      child: const Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.email?.split('@')[0] ?? 'User Name',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Figtree',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.email ?? '@username',
                      style: const TextStyle(
                        color: Color(0xFF767E8C),
                        fontSize: 16,
                        fontFamily: 'ABeeZee',
                        fontWeight: FontWeight.w400,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              // Menu Items
              _SettingsTile(
                icon: Icons.person_outline,
                label: 'Account',
                onTap: () => context.push('/settings/account'),
              ),
              _SettingsTile(
                icon: Icons.color_lens_outlined,
                label: 'Theme',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.style_outlined,
                label: 'Change Mode',
                trailing: Switch.adaptive(
                  value: isDark,
                  activeTrackColor: const Color(0xFF24A19C),
                  onChanged: (isOn) {
                    ref
                        .read(themeProvider.notifier)
                        .setThemeMode(isOn ? ThemeMode.dark : ThemeMode.light);
                  },
                ),
              ),
              const SizedBox(height: 24),
              _SettingsTile(
                icon: Icons.lock_outline,
                label: 'Privacy Policy',
                onTap: () => _launchURL(_privacyPolicyUrl, context),
              ),
              _SettingsTile(
                icon: Icons.description_outlined,
                label: '利用規約',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.info_outline,
                label: 'ライセンス表記',
                onTap: () => showLicensePage(context: context),
              ),
              _SettingsTile(
                icon: Icons.mail_outline,
                label: 'お問い合わせ',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.logout,
                label: 'Log Out',
                onTap: () async {
                  await ref.read(authRepositoryProvider).signOut();
                },
              ),
              const SizedBox(height: 48),
              // Footer
              const Center(
                child: Column(
                  children: [
                    Text(
                      'App Version 1.0.0',
                      style: TextStyle(
                        color: Color(0xFF767E8C),
                        fontSize: 12,
                        fontFamily: 'Figtree',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _launchURL(String url, BuildContext context) async {
    if (!await launchUrl(Uri.parse(url))) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('リンクを開けませんでした')),
        );
      }
    }
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF767E8C), size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF767E8C),
                  fontSize: 16,
                  fontFamily: 'ABeeZee',
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                ),
              ),
            ),
            if (trailing != null)
              trailing!
            else
              const Icon(Icons.chevron_right,
                  color: Color(0xFFE0E5ED), size: 20),
          ],
        ),
      ),
    );
  }
}