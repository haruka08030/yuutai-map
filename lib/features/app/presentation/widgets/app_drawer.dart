import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/features/auth/data/auth_repository.dart';
import 'package:flutter_stock/app/routing/app_router.dart';
import 'package:flutter_stock/features/benefits/domain/yuutai_list_settings.dart';
import 'package:flutter_stock/features/benefits/provider/yuutai_list_settings_provider.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/features/benefits/provider/yuutai_folder_count_provider.dart';
import 'package:flutter_stock/features/folders/domain/entities/folder.dart';
import 'package:flutter_stock/features/folders/presentation/widgets/create_folder_dialog.dart';
import 'package:flutter_stock/features/folders/providers/folder_providers.dart';
import 'package:flutter_stock/core/utils/snackbar_utils.dart';

import 'package:flutter_stock/features/app/presentation/widgets/drawer/drawer_constants.dart';
import 'package:flutter_stock/features/app/presentation/widgets/drawer/drawer_folder_context_menu.dart';
import 'package:flutter_stock/features/app/presentation/widgets/drawer/drawer_folder_tile.dart';
import 'package:flutter_stock/features/app/presentation/widgets/drawer/drawer_footer.dart';
import 'package:flutter_stock/features/app/presentation/widgets/drawer/drawer_guest_body.dart';
import 'package:flutter_stock/features/app/presentation/widgets/drawer/drawer_list_tile.dart';

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
      child: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: isGuest
                  ? DrawerGuestBody(
                      onSignUp: () {
                        Navigator.of(context).pop();
                        ref.read(routerProvider).go('/signup');
                      },
                      onLogin: () {
                        Navigator.of(context).pop();
                        ref.read(routerProvider).go('/login');
                      },
                    )
                  : _MainDrawerBody(
                      selectedFolderId: selectedFolderId,
                      onFolderSelected: onFolderSelected,
                      onAllCouponsTapped: onAllCouponsTapped,
                      onHistoryTapped: onHistoryTapped,
                    ),
            ),
          ),
          if (!isGuest)
            DrawerFooter(
              onAddFolderTap: () {
                Navigator.of(context).pop();
                CreateFolderDialog.show(context);
              },
              onSettingsTap: onSettingsTapped,
            ),
        ],
      ),
    );
  }
}

class _MainDrawerBody extends ConsumerWidget {
  const _MainDrawerBody({
    required this.selectedFolderId,
    required this.onFolderSelected,
    required this.onAllCouponsTapped,
    required this.onHistoryTapped,
  });

  final String? selectedFolderId;
  final Function(String?) onFolderSelected;
  final VoidCallback onAllCouponsTapped;
  final VoidCallback onHistoryTapped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final listFilter = ref.watch(yuutaiListSettingsProvider).listFilter;
    final foldersAsync = ref.watch(foldersProvider);
    final yuutaiCounts = ref.watch(yuutaiCountPerFolderProvider);
    final activeCountAsync = ref.watch(activeUsersYuutaiProvider);
    final historyCountAsync = ref.watch(historyUsersYuutaiProvider);

    final activeCount = activeCountAsync.whenOrNull(data: (l) => l.length) ?? 0;
    final historyCount =
        historyCountAsync.whenOrNull(data: (l) => l.length) ?? 0;
    final isAllSelected =
        selectedFolderId == null && listFilter != YuutaiListFilter.used;
    final isHistorySelected = listFilter == YuutaiListFilter.used;

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: kDrawerHorizontalPadding,
        vertical: kDrawerVerticalPadding,
      ),
      children: [
        DrawerListTile(
          icon: Icons.view_list_outlined,
          iconColor: theme.colorScheme.primary,
          label: 'すべて',
          count: activeCount,
          selected: isAllSelected,
          onTap: onAllCouponsTapped,
        ),
        foldersAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (folders) {
            return Column(
              children: [
                ...folders.map(
                  (folder) => DrawerFolderTile(
                    folder: folder,
                    selected: selectedFolderId == folder.id,
                    count: yuutaiCounts[folder.id] ?? 0,
                    theme: theme,
                    onTap: () => onFolderSelected(folder.id),
                    onDelete: () => _deleteFolder(
                      context,
                      ref,
                      folder,
                      selectedFolderId,
                      onFolderSelected,
                    ),
                    onLongPress: folder.id != null
                        ? (ctx) => showFolderContextMenu(
                              ctx,
                              ref,
                              folder,
                              selectedFolderId: selectedFolderId,
                              onFolderSelected: onFolderSelected,
                            )
                        : null,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        DrawerListTile(
          icon: Icons.history,
          iconColor: AppTheme.secondaryTextColor(context),
          label: '使用済み',
          count: historyCount,
          selected: isHistorySelected,
          onTap: onHistoryTapped,
        ),
      ],
    );
  }

  Future<void> _deleteFolder(
    BuildContext context,
    WidgetRef ref,
    Folder folder,
    String? currentSelectedId,
    Function(String?) onFolderSelected,
  ) async {
    final folderId = folder.id;
    if (folderId == null) return;
    try {
      await ref.read(folderRepositoryProvider).deleteFolder(folderId);
      if (currentSelectedId == folderId) {
        onFolderSelected(null);
      }
    } catch (e) {
      if (context.mounted) showErrorSnackBar(context, e);
    }
  }
}
