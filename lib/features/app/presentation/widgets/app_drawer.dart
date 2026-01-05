import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/folders/presentation/widgets/folders_section.dart';

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
    return Drawer(
      child: SafeArea(
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
        ),
      ), // Corrected: Added missing closing parenthesis for SafeArea
    );
  }
}
