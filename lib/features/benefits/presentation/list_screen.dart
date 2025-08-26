import 'package:flutter/cupertino.dart';

class _Section extends StatefulWidget {
  const _Section({
    required this.title,
    required this.children,
    this.initiallyCollapsed = false,
  });
  final String title;
  final List<Widget> children;
  final bool initiallyCollapsed;
  @override
  State<_Section> createState() => _SectionState();
}

class _SectionState extends State<_Section> {
  late bool _collapsed = widget.initiallyCollapsed;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            widget.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          trailing: Icon(_collapsed ? Icons.expand_more : Icons.expand_less),
          onTap: () => setState(() => _collapsed = !_collapsed),
        ),
        if (!_collapsed) ...widget.children,
      ],
    );
  }
}

class _ItemTile extends ConsumerWidget {
  const _ItemTile({required this.b});
  final UserBenefit b;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BenefitListItem(
      b: b,
      onToggleUsed: () async {
        await ref.read(toggleUsedUsecase)(b.id, !b.isUsed);
      },
      onEdit: () => ListScreen.showAddModal(context, edit: b),
      onDelete: () async {
        final ok = await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: const Text('削除しますか？'),
            content: Text('${b.companyName} / ${b.benefitDetails}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(c, false),
                child: const Text('キャンセル'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(c, true),
                child: const Text('削除'),
              ),
            ],
          ),
        );
        if (ok == true) {
          await ref.read(deleteBenefitUsecase)(b.id);
        }
      },
    );
  }
}
