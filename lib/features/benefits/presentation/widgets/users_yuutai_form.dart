import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_stock/features/benefits/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/features/benefits/presentation/controllers/users_yuutai_edit_controller.dart';
import 'package:flutter_stock/features/folders/providers/folder_providers.dart';

import 'package:intl/intl.dart';

class UsersYuutaiForm extends ConsumerWidget {
  const UsersYuutaiForm({super.key, this.existing, required this.formKey});
  final UsersYuutai? existing;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(usersYuutaiEditControllerProvider(existing));
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
            decoration: InputDecoration(
              labelText: '優待内容',
              hintText: '例: 3000円分の割引券',
              isDense: true,
              suffixIcon: IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: notifier.handleOcr,
              ),
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
          // Expiry Date
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('有効期限'),
            subtitle: Text(_expireSubtitle(controller.expireOn)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (controller.expireOn != null)
                  TextButton(
                    onPressed: () => notifier.setExpireOn(null),
                    child: const Text('クリア'),
                  ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => notifier.showExpiryPicker(context),
                  child: const Text('選択'),
                ),
              ],
            ),
            onTap: () => notifier.showExpiryPicker(context),
          ),
          // Folder Selector
          Consumer(
            builder: (context, ref, _) {
              final foldersAsync = ref.watch(foldersProvider);
              return foldersAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, stack) => const SizedBox.shrink(),
                data: (folders) {
                  if (folders.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  final selectedFolder = controller.selectedFolderId != null
                      ? folders.firstWhere(
                          (f) => f.id == controller.selectedFolderId,
                          orElse: () => folders.first,
                        )
                      : null;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('フォルダ'),
                    subtitle: Text(
                      selectedFolder == null ? '未分類' : selectedFolder.name,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => notifier.selectFolder(context),
                  );
                },
              );
            },
          ),
          // Reminder
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('通知タイミング'),
            subtitle: Text(_buildReminderSubtitle(controller)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => notifier.showReminderPicker(context),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  String _expireSubtitle(DateTime? expireOn) {
    if (expireOn == null) return '未設定';
    final fmt = DateFormat('yyyy/MM/dd (E)', 'ja');
    final dateStr = fmt.format(expireOn);
    final today = DateTime.now();
    final dd = DateTime(
      expireOn.year,
      expireOn.month,
      expireOn.day,
    ).difference(DateTime(today.year, today.month, today.day)).inDays;
    final tail = dd < 0 ? '・期限切れ' : (dd == 0 ? '・本日' : '・残り$dd日');
    return '$dateStr $tail';
  }

  String _buildReminderSubtitle(UsersYuutaiEditState state) {
    final List<String> parts = [];
    state.selectedPredefinedDays.forEach((day, selected) {
      if (selected) {
        parts.add(day == 0 ? '当日' : '$day日前');
      }
    });
    if (state.customDayEnabled && state.customDayValue.isNotEmpty) {
      parts.add('${state.customDayValue}日前 (カスタム)');
    }

    if (parts.isEmpty) return 'なし';
    return parts.join(', ');
  }
}
