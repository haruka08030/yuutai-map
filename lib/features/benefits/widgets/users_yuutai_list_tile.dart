import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/benefits/domain/entities/benefit_status.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/features/benefits/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';

import 'package:flutter_stock/core/utils/date_utils.dart';
import 'package:flutter_stock/core/widgets/app_dialogs.dart';
import 'package:flutter_stock/features/benefits/widgets/expiry_date_display.dart';

class UsersYuutaiListTile extends ConsumerWidget {
  const UsersYuutaiListTile({super.key, required this.benefit, this.subtitle});
  final UsersYuutai benefit;
  final String? subtitle;

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
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (_) => context.push('/yuutai/edit', extra: benefit),
              backgroundColor: appColors?.editActionBackground ?? Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit_outlined,
              label: '編集',
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
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
          child: InkWell(
            onTap: () => context.push('/yuutai/edit', extra: benefit),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: AppTheme.dividerColor(context),
                    ),
                    child: Checkbox(
                      value: isUsed,
                      onChanged: (v) async {
                        if (benefit.id == null) return;
                        await HapticFeedback.lightImpact();
                        final newStatus = v ?? false
                            ? BenefitStatus.used
                            : BenefitStatus.active;
                        await repo.updateStatus(benefit.id!, newStatus);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          benefit.companyName,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: isUsed
                                ? AppTheme.secondaryTextColor(context)
                                : null,
                            decoration: isUsed
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        if (benefit.expiryDate != null) ...[
                          const SizedBox(height: 4),
                          ExpiryDateDisplay(
                            benefit: benefit,
                            isUsed: isUsed,
                            daysRemaining: daysRemaining,
                          ),
                        ],
                        if (subtitle != null) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.benefitChipBackgroundColor(
                                context,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              subtitle!,
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                color: AppTheme.chipForegroundColor(context),
                                fontWeight: FontWeight.w500,
                                decoration: isUsed
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppTheme.dividerColor(context),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
