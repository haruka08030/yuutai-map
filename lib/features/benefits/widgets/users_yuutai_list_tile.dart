import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/features/benefits/presentation/users_yuutai_edit_page.dart';
import 'package:flutter_stock/domain/entities/users_yuutai.dart';

import 'package:intl/intl.dart';

class UsersYuutaiListTile extends ConsumerWidget {
  const UsersYuutaiListTile({super.key, required this.benefit, this.subtitle});
  final UsersYuutai benefit;
  final String? subtitle;

  String _formatExpireDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year) {
      return DateFormat('MM/dd').format(date);
    }
    return DateFormat('yyyy/MM/dd').format(date);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(usersYuutaiRepositoryProvider);

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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UsersYuutaiEditPage(existing: benefit),
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
                  content: Text('「${benefit.companyName}」を削除します。取り消せません。'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('キャンセル'),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('削除'),
                    ),
                  ],
                ),
              );
              if (ok == true && benefit.id != null) {
                await HapticFeedback.heavyImpact();
                await repo.softDelete(benefit.id!);
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UsersYuutaiEditPage(existing: benefit),
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
                  content: Text('「${benefit.companyName}」を削除します。取り消せません。'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('キャンセル'),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('削除'),
                    ),
                  ],
                ),
              );
              if (ok == true && benefit.id != null) {
                await HapticFeedback.heavyImpact();
                await repo.softDelete(benefit.id!);
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
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UsersYuutaiEditPage(existing: benefit),
            ),
          );
        },
        child: Builder(
          builder: (context) {
            final hasSubtitle = benefit.expiryDate != null || subtitle != null;
            final isUsed = benefit.status == 'used';
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                crossAxisAlignment: hasSubtitle
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.center,
                children: [
                  // チェックボックス
                  Checkbox(
                    value: isUsed,
                    onChanged: (v) async {
                      if (benefit.id == null) return;
                      await HapticFeedback.lightImpact();
                      repo.toggleUsed(benefit.id!, v ?? false);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    activeColor: Colors.deepPurple,
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(width: 8),
                  // コンテンツ
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // タイトル（企業名）
                        Text(
                          benefit.companyName,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            decoration:
                                isUsed ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        // 期限日
                        if (benefit.expiryDate != null) ...[
                          const SizedBox(height: 5),
                          Text(
                            _formatExpireDate(benefit.expiryDate!),
                            style: TextStyle(
                              color: const Color(0xffafafaf),
                              fontSize: 14,
                              decoration: isUsed
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ],
                        // 優待内容
                        if (subtitle != null) ...[
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0x1a7990f8),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              subtitle!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.deepPurple,
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
