import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/app/theme/theme_provider.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/core/widgets/app_loading_indicator.dart';
import 'package:flutter_stock/core/utils/url_launcher_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 本番公開前に実際のプライバシーポリシーURLに差し替える（IMPROVEMENTS.md 参照）
const String _privacyPolicyUrl = 'https://your-privacy-policy-url.com';
const String _inquiryUrl = 'https://forms.gle/VGyP1fZV8EPi56nc7';

final packageInfoProvider = FutureProvider<PackageInfo>((ref) async {
  return await PackageInfo.fromPlatform();
});

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGuest = ref.watch(isGuestProvider);
    final user = ref.watch(authRepositoryProvider).currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('設定'), centerTitle: true),
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
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      children: [
        // Guest Section
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color:
                Theme.of(context).extension<AppColors>()?.cardBackground ??
                AppColors.light.cardBackground,
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            border: Border.all(color: AppTheme.dividerColor(context)),
          ),
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  size: 36,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'ゲストユーザー',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'ログインして全ての機能を利用しましょう',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.secondaryTextColor(context),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.push('/login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF24A19C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('ログイン'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.push('/signup'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF24A19C),
                        side: const BorderSide(color: Color(0xFF24A19C)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('新規登録'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _buildSectionHeader('その他'),
        _SettingsTile(
          icon: Icons.privacy_tip_outlined,
          label: 'プライバシーポリシー',
          onTap: () => launchURL(_privacyPolicyUrl, context),
        ),
        _SettingsTile(
          icon: Icons.help_outline_rounded,
          label: 'お問い合わせ',
          onTap: () => launchURL(_inquiryUrl, context),
        ),
        const SizedBox(height: 48),
        Center(
          child: Consumer(
            builder: (context, ref, child) {
              final packageInfo = ref.watch(packageInfoProvider);
              return packageInfo.when(
                data: (info) => Text(
                  'Version ${info.version}',
                  style: TextStyle(
                    color: AppTheme.secondaryTextColor(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                loading: () => const AppLoadingIndicator(),
                error: (err, stack) => const Text('バージョン情報取得エラー'),
              );
            },
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

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      children: [
        // Profile Section
        Container(
          margin: const EdgeInsets.only(bottom: 40),
          decoration: BoxDecoration(
            color:
                Theme.of(context).extension<AppColors>()?.cardBackground ??
                AppColors.light.cardBackground,
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            border: Border.all(color: AppTheme.dividerColor(context)),
          ),
          child: InkWell(
            onTap: () => context.push('/settings/account'),
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF24A19C).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 32,
                      color: Color(0xFF24A19C),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.email?.split('@')[0] ?? 'ユーザー',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email ?? '',
                          style: TextStyle(
                            color: AppTheme.secondaryTextColor(context),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppTheme.dividerColor(context),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildSectionHeader('アプリ設定'),
        _SettingsTile(
          icon: isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
          label: 'ダークモード',
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
        _SettingsTile(
          icon: Icons.privacy_tip_outlined,
          label: 'プライバシーポリシー',
          onTap: () => launchURL(_privacyPolicyUrl, context),
        ),
        _SettingsTile(
          icon: Icons.description_outlined,
          label: '利用規約',
          onTap: () {},
        ),
        _SettingsTile(
          icon: Icons.info_outline_rounded,
          label: 'ライセンス表記',
          onTap: () => showLicensePage(context: context),
        ),
        _SettingsTile(
          icon: Icons.help_outline_rounded,
          label: 'お問い合わせ',
          onTap: () => launchURL(_inquiryUrl, context),
        ),
        _SettingsTile(
          icon: Icons.logout_rounded,
          label: 'ログアウト',
          labelColor: Colors.redAccent,
          onTap: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('ログアウト'),
                content: const Text('ログアウトしますか？'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('キャンセル'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('ログアウト'),
                  ),
                ],
              ),
            );
            if (confirm == true) {
              await ref.read(authRepositoryProvider).signOut();
            }
          },
        ),
        const SizedBox(height: 48),
        Center(
          child: Consumer(
            builder: (context, ref, child) {
              final packageInfo = ref.watch(packageInfoProvider);
              return packageInfo.when(
                data: (info) => Text(
                  'Version ${info.version}',
                  style: TextStyle(
                    color: AppTheme.secondaryTextColor(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                loading: () => const AppLoadingIndicator(),
                error: (err, stack) => const Text('バージョン情報取得エラー'),
              );
            },
          ),
        ),
      ],
    );
  }
}

Widget _buildSectionHeader(String title) {
  return Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 12),
    child: Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF24A19C),
        letterSpacing: 0.5,
      ),
    ),
  );
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    this.onTap,
    this.trailing,
    this.labelColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color:
            Theme.of(context).extension<AppColors>()?.cardBackground ??
            AppColors.light.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(
          color: AppTheme.dividerColor(context).withValues(alpha: 0.5),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (labelColor ?? const Color(0xFF24A19C)).withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: labelColor ?? const Color(0xFF24A19C),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.outfit(
                    color:
                        labelColor ?? Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (trailing != null)
                trailing!
              else
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.dividerColor(context),
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
