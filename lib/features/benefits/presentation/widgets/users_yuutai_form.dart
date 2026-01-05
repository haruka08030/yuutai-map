import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stock/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/features/benefits/presentation/controllers/users_yuutai_edit_controller.dart';
import 'package:flutter_stock/features/folders/providers/folder_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class UsersYuutaiForm extends ConsumerWidget {
  const UsersYuutaiForm({super.key, this.existing, required this.formKey});
  final UsersYuutai? existing;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(usersYuutaiEditControllerProvider(existing));
    final notifier = ref.read(usersYuutaiEditControllerProvider(existing).notifier);
    final titleCtl = ref.watch(titleControllerProvider(existing));
    final benefitContentCtl = ref.watch(benefitContentControllerProvider(existing));
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
            validator: (v) => (v == null || v.trim().isEmpty) ? '企業名を入力してください' : null,
            readOnly: true,
            onTap: () async {
              final company = await context.push<String>('/company/search');
              if (company != null) {
                notifier.setCompanyName(company);
              }
            },
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
                  onPressed: () => _openExpireSheet(context, controller.expireOn, notifier.setExpireOn),
                  child: const Text('選択'),
                ),
              ],
            ),
            onTap: () => _openExpireSheet(context, controller.expireOn, notifier.setExpireOn),
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
                      ? folders.firstWhere((f) => f.id == controller.selectedFolderId, orElse: () => folders.first)
                      : null;
                  return ListTile(
                     contentPadding: EdgeInsets.zero,
                     title: const Text('フォルダ'),
                     subtitle: Text(selectedFolder == null ? '未分類' : selectedFolder.name),
                     trailing: const Icon(Icons.chevron_right),
                     onTap: () async {
                       final result = await context.push<String?>('/folders/select');
                       notifier.setSelectedFolderId(result);
                     },
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
            onTap: () => _openReminderPicker(context, notifier, controller),
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
    final dd = DateTime(expireOn.year, expireOn.month, expireOn.day)
        .difference(DateTime(today.year, today.month, today.day))
        .inDays;
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

  Future<void> _openExpireSheet(BuildContext context, DateTime? currentExpireOn, Function(DateTime?) onDateChanged) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final now = DateTime.now();
        DateTime today(DateTime d) => DateTime(d.year, d.month, d.day);
        DateTime? pending = currentExpireOn;
        return StatefulBuilder(
          builder: (ctx, setLocalState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: MediaQuery.of(ctx).viewInsets.bottom + 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('キャンセル')),
                        FilledButton(onPressed: () { onDateChanged(pending); Navigator.of(ctx).pop(); }, child: const Text('決定')),
                      ],
                    ),
                    CalendarDatePicker(
                      initialDate: pending ?? today(now),
                      firstDate: today(now),
                      lastDate: DateTime(now.year + 5),
                      onDateChanged: (d) => setLocalState(() => pending = today(d)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _openReminderPicker(BuildContext context, UsersYuutaiEditController notifier, UsersYuutaiEditState controller) async {
    final tempSelectedDays = Map<int, bool>.from(controller.selectedPredefinedDays);
    bool tempCustomEnabled = controller.customDayEnabled;
    final tempCustomCtl = TextEditingController(text: controller.customDayValue);

    try {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (dialogContext, setDialogState) {
              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: MediaQuery.of(dialogContext).viewInsets.bottom + 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              setDialogState(() {
                                tempSelectedDays.updateAll((key, value) => false);
                                tempCustomEnabled = false;
                                tempCustomCtl.clear();
                              });
                            },
                            child: const Text('クリア'),
                          ),
                          FilledButton(
                            onPressed: () {
                              notifier.updateReminderSettings(tempSelectedDays, tempCustomEnabled, tempCustomCtl.text);
                              Navigator.of(dialogContext).pop();
                            },
                            child: const Text('決定'),
                          ),
                        ],
                      ),
                      const Divider(),
                      ...tempSelectedDays.entries.map((entry) {
                        return CheckboxListTile(
                          title: Text(entry.key == 0 ? '当日' : '${entry.key}日前'),
                          value: entry.value,
                          onChanged: (bool? value) {
                            setDialogState(() {
                              tempSelectedDays[entry.key] = value!;
                            });
                          },
                        );
                      }),
                      CheckboxListTile(
                        title: Row(
                          children: [
                            const Text('カスタム:'),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 60,
                              child: TextFormField(
                                controller: tempCustomCtl,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(isDense: true),
                                enabled: tempCustomEnabled,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('日前'),
                          ],
                        ),
                        value: tempCustomEnabled,
                        onChanged: (bool? value) {
                          setDialogState(() {
                            tempCustomEnabled = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    } finally {
      tempCustomCtl.dispose();
    }
  }
}
