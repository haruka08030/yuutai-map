import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../domain/user_benefit.dart';
import 'due_badge.dart';

class BenefitListItem extends StatelessWidget {
  const BenefitListItem({
    super.key,
    required this.b,
    required this.onToggleUsed,
    required this.onEdit,
    required this.onDelete,
  });
  final UserBenefit b;
  final VoidCallback onToggleUsed;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(b.id),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onToggleUsed(),
            icon: b.isUsed ? Icons.undo : Icons.check,
            label: b.isUsed ? '戻す' : '使用済',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onEdit(),
            icon: Icons.edit,
            label: '編集',
          ),
          SlidableAction(
            onPressed: (_) => onDelete(),
            icon: Icons.delete,
            backgroundColor: Colors.red,
            label: '削除',
          ),
        ],
      ),
      child: ListTile(
        leading: Checkbox(value: b.isUsed, onChanged: (_) => onToggleUsed()),
        title: Text(
          b.companyName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          b.benefitDetails,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: DueBadge(daysLeft: b.daysLeft),
      ),
    );
  }
}
