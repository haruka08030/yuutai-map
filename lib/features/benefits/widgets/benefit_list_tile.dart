import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/benefits/provider/benefit_providers.dart';
import 'package:flutter_stock/features/benefits/presentation/benefit_edit_page.dart';
import 'package:flutter_stock/domain/entities/user_benefit.dart';

class BenefitListTile extends ConsumerWidget {
  const BenefitListTile({super.key, required this.benefit, this.subtitle});
  final UserBenefit benefit;
  final String? subtitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(userBenefitRepositoryProvider);

    return Slidable(
      key: ValueKey(benefit.id),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: '編集',
            onPressed: (_) async {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                isDismissible: true,
                enableDrag: true,
                useSafeArea: true,
                backgroundColor: Theme.of(context).colorScheme.surface,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (ctx) => FractionallySizedBox(
                  heightFactor: 0.6,
                  child: BenefitEditPage(existing: benefit, asSheet: true),
                ),
              );
            },
          ),
          SlidableAction(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: '削除',
          onPressed: (_) async {
            await HapticFeedback.lightImpact();
            if (!context.mounted) return;
            final ok = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                  title: const Text('削除しますか？'),
                  content: Text('「${benefit.title}」を削除します。取り消せません。'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('キャンセル'),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('削除'),
                    ),
                  ],
                ),
              );
              if (ok == true) {
                await HapticFeedback.heavyImpact();
                await repo.softDelete(benefit.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('削除しました'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: '編集',
            onPressed: (_) async {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                isDismissible: true,
                enableDrag: true,
                useSafeArea: true,
                backgroundColor: Theme.of(context).colorScheme.surface,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (ctx) => FractionallySizedBox(
                  heightFactor: 0.6,
                  child: BenefitEditPage(existing: benefit, asSheet: true),
                ),
              );
            },
          ),
          SlidableAction(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: '削除',
          onPressed: (_) async {
            await HapticFeedback.lightImpact();
            if (!context.mounted) return;
            final ok = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                  title: const Text('削除しますか？'),
                  content: Text('「${benefit.title}」を削除します。取り消せません。'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('キャンセル'),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('削除'),
                    ),
                  ],
                ),
              );
              if (ok == true) {
                await HapticFeedback.heavyImpact();
                await repo.softDelete(benefit.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('削除しました'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      child: ListTile(
        leading: Checkbox(
          value: benefit.isUsed,
          onChanged: (v) async {
            await HapticFeedback.lightImpact();
            repo.toggleUsed(benefit.id, v ?? false);
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          activeColor: Colors.teal,
        ),
        title: Text(
          benefit.title,
          style: TextStyle(
            decoration: benefit.isUsed ? TextDecoration.lineThrough : null,
            color: benefit.isUsed
                ? Theme.of(context).disabledColor
                : Theme.of(context).textTheme.titleMedium?.color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        // Expiration chip removed per request
        // trailing: _Badge(expireOn: benefit.expireOn),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        onTap: () async {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: true,
            enableDrag: true,
            useSafeArea: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (ctx) => FractionallySizedBox(
              heightFactor: 0.6,
              child: BenefitEditPage(existing: benefit, asSheet: true),
            ),
          );
        },
      ),
    );
  }
}
