import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';

class AccountDetailPage extends ConsumerStatefulWidget {
  const AccountDetailPage({super.key});

  @override
  ConsumerState<AccountDetailPage> createState() => _AccountDetailPageState();
}

class _AccountDetailPageState extends ConsumerState<AccountDetailPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

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
                  _buildFieldLabel('お名前'),
                  const SizedBox(height: 12),
                  _buildTextField(_nameController, '名前を入力'),
                  const SizedBox(height: 24),
                  _buildFieldLabel('メールアドレス'),
                  const SizedBox(height: 12),
                  _buildTextField(
                    _emailController,
                    'name@example.com',
                    readOnly: true,
                  ),
                  const SizedBox(height: 48),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.redAccent.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '危険な操作',
                          style: GoogleFonts.outfit(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'アカウントを削除すると、すべてのデータが完全に消去されます。',
                          style: TextStyle(
                            color: AppTheme.secondaryTextColor(context),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _showDeleteConfirmation,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.redAccent,
                              side: const BorderSide(color: Colors.redAccent),
                            ),
                            child: const Text('アカウントを削除する'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final currentContext =
                        context; // Store context before async gap
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
                      // Log the full error for debugging
                      debugPrint('Failed to update profile: $e');
                      if (!currentContext.mounted) return;
                      ScaffoldMessenger.of(currentContext).showSnackBar(
                        const SnackBar(content: Text('保存に失敗しました。もう一度お試しください。')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF24A19C),
                    foregroundColor: Colors.white,
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

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1B1C1F),
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
        fillColor: readOnly ? const Color(0xFFF9FAFB) : Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      style: GoogleFonts.outfit(
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
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
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
