import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/features/folders/presentation/widgets/folders_section.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({
    super.key,
    required this.selectedFolderId,
    required this.onFolderSelected,
    required this.onMapTapped,
    required this.onSettingsTapped,
    required this.onAllCouponsTapped,
  });

  final String? selectedFolderId;
  final Function(String?) onFolderSelected;
  final VoidCallback onMapTapped;
  final VoidCallback onSettingsTapped;
  final VoidCallback onAllCouponsTapped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FoldersSection(
            selectedFolderId: selectedFolderId,
            onFolderSelected: onFolderSelected,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.confirmation_number),
            title: const Text('すべての優待'),
            selected: selectedFolderId == null,
            onTap: onAllCouponsTapped,
          ),
          const Divider(),
          // Used Coupons (Moved to bottom)
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('使用済み'),
            onTap: () {
              // TODO: Navigate to history view
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
