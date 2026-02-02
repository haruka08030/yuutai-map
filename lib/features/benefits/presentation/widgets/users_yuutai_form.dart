import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_stock/features/benefits/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/features/benefits/presentation/controllers/users_yuutai_edit_controller.dart';

class UsersYuutaiForm extends ConsumerWidget {
  const UsersYuutaiForm({super.key, this.existing, required this.formKey});
  final UsersYuutai? existing;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(
      usersYuutaiEditControllerProvider(existing).notifier,
    );
    final titleCtl = ref.watch(titleControllerProvider(existing));
    final benefitContentCtl = ref.watch(
      benefitContentControllerProvider(existing),
    );
    final notesCtl = ref.watch(notesControllerProvider(existing));

    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Company Name
          TextFormField(
            controller: titleCtl,
            decoration: const InputDecoration(
              labelText: '企業名',
              hintText: '例: 〇〇ホールディングス',
              suffixIcon: Icon(Icons.search),
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? '企業名を入力してください' : null,
            readOnly: true,
            onTap: () => notifier.selectCompany(context),
          ),
          const SizedBox(height: 12),
          // Benefit Content
          TextFormField(
            controller: benefitContentCtl,
            decoration: const InputDecoration(
              labelText: '優待内容',
              hintText: '例: 3000円分の割引券',
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          // Notes
          TextFormField(
            controller: notesCtl,
            decoration: const InputDecoration(
              labelText: 'メモ',
              hintText: '自由記述',
              border: OutlineInputBorder(),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          // Folder（フォルダがなくても表示し、選択画面で新規作成できる）
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('フォルダ'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => notifier.selectFolder(context),
          ),
        ],
      ),
    );
  }
}
