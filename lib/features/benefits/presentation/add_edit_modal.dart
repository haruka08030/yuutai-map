import 'package:flutter/material.dart';
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text('サインインが必要です（設定から）')),
);
}
return;
}
final payload = UserBenefit(
id: widget.edit?.id ?? 'temp',
userId: uid,
companyCode: _companyCode.text.trim().isEmpty ? null : _companyCode.text.trim(),
companyName: _companyName.text.trim(),
benefitDetails: _details.text.trim(),
expirationDate: _picked!,
isUsed: widget.edit?.isUsed ?? false,
notes: null,
);
if (widget.edit == null) {
await ref.read(addBenefitUsecase)(payload);
} else {
await ref.read(updateBenefitUsecase)(payload.copyWith(id: widget.edit!.id));
}
if (context.mounted) Navigator.pop(context);
},
child: Text(editing ? '更新' : '追加'),
)
],
)
],
),
),
),
);
}
}


class _ReminderChip extends StatefulWidget {
const _ReminderChip({required this.label});
final String label;
@override
State<_ReminderChip> createState() => _ReminderChipState();
}


class _ReminderChipState extends State<_ReminderChip> {
bool _on = false;
@override
Widget build(BuildContext context) {
return FilterChip(
label: Text(widget.label),
selected: _on,
onSelected: (v) => setState(() => _on = v),
);
}
}