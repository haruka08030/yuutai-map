import 'package:flutter/material.dart';

import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/features/app/presentation/widgets/drawer/drawer_constants.dart';

/// ドロワー下部（フォルダ追加ボタンなど）
class DrawerFooter extends StatelessWidget {
  const DrawerFooter({
    super.key,
    required this.onAddFolderTap,
    required this.onSettingsTap,
  });

  final VoidCallback onAddFolderTap;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.only(
        left: kDrawerHorizontalPadding,
        right: kDrawerHorizontalPadding,
        bottom: MediaQuery.of(context).padding.bottom + 8,
        top: 8,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.extension<AppColors>()?.divider ??
                colorScheme.outlineVariant,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            TextButton.icon(
              onPressed: onAddFolderTap,
              icon: Icon(
                Icons.create_new_folder_outlined,
                size: 20,
                color: colorScheme.primary,
              ),
              label: Text(
                'フォルダを追加',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: colorScheme.primary,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: colorScheme.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
