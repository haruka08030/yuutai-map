import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/core/widgets/loading_elevated_button.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';

class AccountDetailPage extends ConsumerStatefulWidget {
  const AccountDetailPage({super.key});

  @override
  ConsumerState<AccountDetailPage> createState() => _AccountDetailPageState();
}

class _AccountDetailPageState extends ConsumerState<AccountDetailPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authRepositoryProvider).currentUser;
    _nameController = TextEditingController(
      text: user?.userMetadata?['username'] ?? '',
    );
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('アカウント詳細'), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                children: [
                  _buildFieldLabel('ユーザー名'),
                  const SizedBox(height: 12),
                  _buildTextField(_nameController, 'ユーザー名を入力'),
                  const SizedBox(height: 24),
                  _buildFieldLabel('メールアドレス'),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => context.go('/settings/account/email/edit'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _emailController.text.isNotEmpty
                                  ? _emailController.text
                                  : '未設定',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: _emailController.text.isNotEmpty
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                        : AppTheme.secondaryTextColor(context),
                                    fontSize: 16,
                                  ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: AppTheme.placeholderColor(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildLinkedAccountsSection(),
                  const SizedBox(height: 32),
                  const SizedBox(height: 48),
                  Center(
                    child: TextButton(
                      onPressed: _showDeleteConfirmation,
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.secondaryTextColor(context),
                      ),
                      child: const Text('アカウントを削除する'),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: LoadingElevatedButton(
                  onPressed: _saveProfile,
                  isLoading: _isSaving,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    '変更を保存する',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    final currentContext = context;
    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.updateUserProfile(
        username: _nameController.text,
      );
      ref.invalidate(authRepositoryProvider);
      if (!currentContext.mounted) return;
      ScaffoldMessenger.of(currentContext).showSnackBar(
        const SnackBar(content: Text('変更を保存しました')),
      );
    } catch (e) {
      debugPrint('Failed to update profile: $e');
      if (!currentContext.mounted) return;
      ScaffoldMessenger.of(currentContext).showSnackBar(
        const SnackBar(content: Text('保存に失敗しました。もう一度お試しください。')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  static String _providerLabel(String provider) {
    switch (provider) {
      case 'email':
        return 'メール';
      case 'google':
        return 'Google';
      case 'apple':
        return 'Apple';
      default:
        return provider;
    }
  }

  Widget _buildLinkedAccountsSection() {
    final identitiesAsync = ref.watch(userIdentitiesProvider);
    return identitiesAsync.when(
      data: (identities) {
        final providers = identities.map((i) => i.provider).toSet();
        final hasGoogle = providers.contains('google');
        final labels = <String>[];
        if (providers.contains('email')) labels.add('メール');
        if (providers.contains('google')) labels.add('Google');
        if (providers.contains('apple')) labels.add('Apple');

        // 前回のログイン方法: lastSignInAt が最も新しい identity
        UserIdentity? lastUsedIdentity;
        DateTime? latestAt;
        for (final i in identities) {
          final at = i.lastSignInAt;
          if (at == null || at.isEmpty) continue;
          final dt = DateTime.tryParse(at);
          if (dt != null && (latestAt == null || dt.isAfter(latestAt))) {
            latestAt = dt;
            lastUsedIdentity = i;
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel('ログイン方法'),
            const SizedBox(height: 12),
            if (labels.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  '連携済み: ${labels.join('、')}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.secondaryTextColor(context),
                      ),
                ),
              ),
            if (lastUsedIdentity != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  '前回のログイン: ${_providerLabel(lastUsedIdentity.provider)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.secondaryTextColor(context),
                      ),
                ),
              ),
            ],
            if (!hasGoogle) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _linkGoogle(currentContext: context),
                icon: const Icon(Icons.add_link, size: 20),
                label: const Text('Googleアカウントを連携する'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Future<void> _linkGoogle({required BuildContext currentContext}) async {
    try {
      await ref.read(authRepositoryProvider).linkGoogleIdentity();
      if (!currentContext.mounted) return;
      ref.invalidate(userIdentitiesProvider);
      ScaffoldMessenger.of(currentContext).showSnackBar(
        const SnackBar(content: Text('Googleアカウントを連携しました')),
      );
    } on AuthException catch (e) {
      if (!currentContext.mounted) return;
      ScaffoldMessenger.of(currentContext).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      if (!currentContext.mounted) return;
      ScaffoldMessenger.of(currentContext).showSnackBar(
        const SnackBar(content: Text('連携に失敗しました。しばらくしてからお試しください。')),
      );
    }
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: readOnly
            ? Theme.of(context).colorScheme.surfaceContainerHighest
            : Theme.of(context).colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: readOnly
                ? AppTheme.secondaryTextColor(context)
                : const Color(0xFF1B1C1F),
            fontSize: 16,
          ),
    );
  }

  Future<void> _showDeleteConfirmation() async {
    final currentContext = context; // Store context before async gap
    final confirmed = await showDialog<bool>(
      context: currentContext,
      builder: (context) => AlertDialog(
        title: const Text('アカウント削除'),
        content: const Text(
          'アカウントを削除すると、登録されたすべての優待データやフォルダが完全に削除されます。この操作は取り消せません。本当に削除しますか？',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text('削除する'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(authRepositoryProvider).deleteAccount();
        if (!currentContext.mounted) return;
        // Navigate to login/home after successful deletion
        if (currentContext.mounted) {
          currentContext.go('/login');
        }
      } catch (e) {
        debugPrint('Failed to delete account: $e');
        if (!currentContext.mounted) return;
        ScaffoldMessenger.of(
          currentContext,
        ).showSnackBar(const SnackBar(content: Text('削除に失敗しました。もう一度お試しください。')));
      }
    }
  }
}
