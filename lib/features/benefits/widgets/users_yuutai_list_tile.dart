import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stock/features/benefits/presentation/widgets/add_yuutai_sheet.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/benefits/domain/entities/benefit_status.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/features/benefits/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/features/folders/presentation/folder_selection_page.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/core/utils/date_utils.dart';
import 'package:flutter_stock/core/widgets/app_dialogs.dart';
import 'package:flutter_stock/features/benefits/widgets/expiry_date_display.dart';

Future<void> _moveBenefitToFolder(
  BuildContext context,
  WidgetRef ref,
  UsersYuutai benefit,
) async {
  await HapticFeedback.lightImpact();
  if (!context.mounted) return;
  final result = await showModalBottomSheet<String?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      decoration: BoxDecoration(
        color: Theme.of(sheetContext).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: const FolderSelectionSheetContent(),
    ),
  );
  if (!context.mounted || benefit.id == null) return;
  // result == null: キャンセル or 未分類。ここでは「変更なし」として扱う
  if (result == null) return;
  final repo = ref.read(usersYuutaiRepositoryProvider);
  await repo.upsert(
    benefit.copyWith(folderId: result),
    scheduleReminders: false,
  );
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('フォルダに移動しました')),
  );
}

class UsersYuutaiListTile extends ConsumerWidget {
  const UsersYuutaiListTile({
    super.key,
    required this.benefit,
    this.stockCode,
  });
  final UsersYuutai benefit;
  final String? stockCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(usersYuutaiRepositoryProvider);
    final daysRemaining = benefit.expiryDate != null
        ? calculateDaysRemaining(benefit.expiryDate!)
        : null;
    final isUsed = benefit.status == BenefitStatus.used;
    final appColors = Theme.of(context).extension<AppColors>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Slidable(
        key: ValueKey(benefit.id),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.4,
          children: [
            SlidableAction(
              onPressed: (_) => _moveBenefitToFolder(context, ref, benefit),
              backgroundColor:
                  appColors?.folderActionBackground ?? Colors.blue.shade700,
              foregroundColor: Colors.white,
              icon: Icons.folder_outlined,
              label: 'フォルダ',
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
            ),
            SlidableAction(
              onPressed: (_) =>
                  YuutaiEditSheet.show(context, existing: benefit),
              backgroundColor:
                  appColors?.editActionBackground ?? Colors.teal.shade700,
              foregroundColor: Colors.white,
              icon: Icons.edit_outlined,
              label: '編集',
              borderRadius: BorderRadius.zero,
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (_) async {
                await HapticFeedback.lightImpact();
                if (!context.mounted) return;
                final ok = await showConfirmationDialog(
                  context: context,
                  title: '削除しますか？',
                  content: '「${benefit.companyName}」を削除します。取り消せません。',
                  confirmButtonColor: appColors?.deleteActionBackground,
                );
                if (ok == true && benefit.id != null) {
                  await HapticFeedback.heavyImpact();
                  await repo.delete(benefit.id!);
                }
              },
              backgroundColor: appColors?.deleteActionBackground ?? Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete_outline,
              label: '削除',
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(12),
              ),
            ),
          ],
        ),
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            side: BorderSide(
              color: AppTheme.dividerColor(context),
              width: 1,
            ),
          ),
          child: InkWell(
            onTap: () => YuutaiEditSheet.show(context, existing: benefit),
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left accent bar（ClipRRectでカードの角丸に合わせてクリップ）
                    Container(
                      width: 3,
                      decoration: BoxDecoration(
                        color: isUsed
                            ? AppTheme.secondaryTextColor(context)
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.6),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                        child: Row(
                          children: [
                            Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor:
                                    AppTheme.dividerColor(context),
                                checkboxTheme: CheckboxThemeData(
                                  side: BorderSide(
                                    width: 1.5,
                                    color: AppTheme.dividerColor(context),
                                  ),
                                  fillColor: WidgetStateProperty.resolveWith(
                                    (states) {
                                      if (states
                                          .contains(WidgetState.selected)) {
                                        return Theme.of(context)
                                            .colorScheme
                                            .primary;
                                      }
                                      return Colors.transparent;
                                    },
                                  ),
                                  checkColor: WidgetStateProperty.all(
                                    Theme.of(context).colorScheme.onPrimary,
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                              child: Checkbox(
                                value: isUsed,
                                onChanged: (v) async {
                                  if (benefit.id == null) return;
                                  await HapticFeedback.lightImpact();
                                  final newStatus = v ?? false
                                      ? BenefitStatus.used
                                      : BenefitStatus.active;
                                  await repo.updateStatus(
                                      benefit.id!, newStatus);
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    benefit.companyName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: isUsed
                                              ? AppTheme.secondaryTextColor(
                                                  context,
                                                )
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                          decoration: isUsed
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                  ),
                                  // 優待内容（グレー・やや小）
                                  if (benefit.benefitDetail != null &&
                                      benefit.benefitDetail!
                                          .trim()
                                          .isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      benefit.benefitDetail!.trim(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: isUsed
                                                ? AppTheme.secondaryTextColor(
                                                    context,
                                                  )
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                            decoration: isUsed
                                                ? TextDecoration.lineThrough
                                                : null,
                                          ),
                                    ),
                                  ],
                                  if (stockCode != null &&
                                      stockCode!.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceContainerHighest,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '証券コード: $stockCode',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                      ),
                                    ),
                                  ],
                                  if (benefit.expiryDate != null) ...[
                                    const SizedBox(height: 8),
                                    ExpiryDateDisplay(
                                      benefit: benefit,
                                      isUsed: isUsed,
                                      daysRemaining: daysRemaining,
                                      useChipStyle: true,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: AppTheme.secondaryTextColor(context),
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
