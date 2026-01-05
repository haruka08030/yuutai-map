import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';

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
    _nameController = TextEditingController(text: user?.userMetadata?['username'] ?? '');
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Content
            Positioned.fill(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const SizedBox(height: 60),
                  // Form Fields
                  _buildFieldLabel('Name'),
                  const SizedBox(height: 12),
                  _buildTextField(_nameController, 'Name'),
                  const SizedBox(height: 24),
                  _buildFieldLabel('Email'),
                  const SizedBox(height: 12),
                  _buildTextField(_emailController, 'name@example.com', readOnly: true),
                  const SizedBox(height: 24),
                  _buildFieldLabel('Password'),
                  const SizedBox(height: 12),
                  _buildPasswordButton(),
                  const SizedBox(height: 48),
                  Center(
                    child: TextButton(
                      onPressed: _showDeleteConfirmation,
                      child: const Text(
                        'アカウント削除',
                        style: TextStyle(
                          color: Color(0xFF767E8C),
                          fontSize: 12,
                          fontFamily: 'Figtree',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100), // Extra space for save button
                ],
              ),
            ),
            // Header
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF1B1C1F)),
                      onPressed: () => context.pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const Expanded(
                      child: Text(
                        'Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF1B1C1F),
                          fontSize: 18,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24), // Spacer to balance back button
                  ],
                ),
              ),
            ),
            // Footer (Save Button)
            Positioned(
              left: 24,
              right: 24,
              bottom: 24,
              child: GestureDetector(
                onTap: () {
                  // TODO: Implement save logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saving changes...')),
                  );
                },
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.all(20),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF24A19C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Save Changes',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Actor',
                        fontWeight: FontWeight.w400,
                        height: 1.11,
                      ),
                    ),
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
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF1B1C1F),
        fontSize: 16,
        fontFamily: 'Actor',
        fontWeight: FontWeight.w400,
        height: 1.25,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool readOnly = false}) {
    return Container(
      height: 56,
      decoration: ShapeDecoration(
        color: const Color(0xFFF6F7F9),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE0E5ED)),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFFA9B0C5),
              fontSize: 16,
              fontFamily: 'ABeeZee',
              fontWeight: FontWeight.w400,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            border: InputBorder.none,
          ),
          style: TextStyle(
            color: readOnly ? const Color(0xFFA9B0C5) : const Color(0xFF1B1C1F),
            fontSize: 16,
            fontFamily: 'ABeeZee',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE0E5ED)),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Implement password change
        },
        borderRadius: BorderRadius.circular(16),
        child: const Center(
          child: Text(
            'Change Password',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF767E8C),
              fontSize: 18,
              fontFamily: 'Actor',
              fontWeight: FontWeight.w400,
              height: 1.11,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('アカウント削除の確認'),
        content: const Text(
            'アカウントを削除すると、登録されたすべての優待データやフォルダが完全に削除されます。この操作は取り消せません。本当に削除しますか？'),
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

    if (confirmed == true) {
      try {
        await ref.read(authRepositoryProvider).deleteAccount();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('アカウントを削除しました')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('削除に失敗しました: $e')),
        );
      }
    }
  }
}
