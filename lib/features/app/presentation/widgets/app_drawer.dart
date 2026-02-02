import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/folders/presentation/widgets/folders_section.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/app/routing/app_router.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({
    super.key,
    required this.selectedFolderId,
    required this.onFolderSelected,
    required this.onMapTapped,
    required this.onSettingsTapped,
    required this.onAllCouponsTapped,
    required this.onHistoryTapped,
  });

  final String? selectedFolderId;
  final Function(String?) onFolderSelected;
  final VoidCallback onMapTapped;
  final VoidCallback onSettingsTapped;
  final VoidCallback onAllCouponsTapped;
  final VoidCallback onHistoryTapped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGuest = ref.watch(isGuestProvider);

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            if (isGuest) ...[
              ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('新規登録'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the drawer
                  ref.read(routerProvider).go('/signup');
                },
              ),
              ListTile(
                leading: const Icon(Icons.login),
                title: const Text('ログイン'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the drawer
                  ref.read(routerProvider).go('/login');
                },
              ),
            ] else ...[
              FoldersSection(
                selectedFolderId: selectedFolderId,
                onFolderSelected: onFolderSelected,
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.confirmation_number),
                title: const Text('すべて'),
                selected: selectedFolderId == null,
                onTap: onAllCouponsTapped,
              ),
              const Divider(),
              // Used Coupons (Moved to bottom)
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('使用済み'),
                onTap: onHistoryTapped,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
