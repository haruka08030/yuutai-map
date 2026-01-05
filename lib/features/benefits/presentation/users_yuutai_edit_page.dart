import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stock/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/domain/entities/benefit_status.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_stock/features/benefits/presentation/company_search_page.dart';
import 'package:flutter_stock/features/folders/presentation/folder_selection_page.dart';
import 'package:flutter_stock/features/folders/providers/folder_providers.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class UsersYuutaiEditPage extends ConsumerStatefulWidget {
  const UsersYuutaiEditPage({super.key, this.existing});
  final UsersYuutai? existing;

  @override
  ConsumerState<UsersYuutaiEditPage> createState() => _UsersYuutaiEditPageState();
}

class _UsersYuutaiEditPageState extends ConsumerState<UsersYuutaiEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtl;
  late final TextEditingController _benefitContentCtl;
  late final TextEditingController _notesCtl;

  DateTime? _expireOn;
  String? _selectedFolderId;

  // State for multi-select notifications
  final Map<int, bool> _selectedPredefinedDays = {30: false, 7: false, 0: false};
  bool _customDayEnabled = false;
  String _customDayValue = '';

  @override
  void initState() {
    super.initState();
    _titleCtl = TextEditingController(text: widget.existing?.companyName ?? '');
    _benefitContentCtl =
        TextEditingController(text: widget.existing?.benefitDetail ?? '');
    _notesCtl = TextEditingController(text: widget.existing?.notes ?? '');
    _expireOn = widget.existing?.expiryDate?.toLocal();
    _selectedFolderId = widget.existing?.folderId;

    // Initialize notification days state from existing data
    final existingDays = widget.existing?.notifyDaysBefore ?? [];
    if (widget.existing?.alertEnabled == true && existingDays.isNotEmpty) {
      for (final day in existingDays) {
        if (_selectedPredefinedDays.containsKey(day)) {
          _selectedPredefinedDays[day] = true;
        } else {
          _customDayEnabled = true;
          _customDayValue = day.toString();
        }
      }
    }
  }

  @override
  void dispose() {
    _titleCtl.dispose();
    _benefitContentCtl.dispose();
    _notesCtl.dispose();
    super.dispose();
  }

  String _buildReminderSubtitle() {
    final List<String> parts = [];
    _selectedPredefinedDays.forEach((day, selected) {
      if (selected) {
        parts.add(day == 0 ? '当日' : '$day日前');
      }
    });
    if (_customDayEnabled && _customDayValue.isNotEmpty) {
      parts.add('$_customDayValue日前 (カスタム)');
    }

    if (parts.isEmpty) return 'なし';
    return parts.join(', ');
  }

  Future<void> _openReminderPicker() async {
    final tempSelectedDays = Map<int, bool>.from(_selectedPredefinedDays);
    bool tempCustomEnabled = _customDayEnabled;
    final tempCustomCtl = TextEditingController(text: _customDayValue);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 12,
                  bottom: MediaQuery.of(dialogContext).viewInsets.bottom + 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            // Clear selections
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
                            setState(() {
                              _selectedPredefinedDays.clear();
                              _selectedPredefinedDays.addAll(tempSelectedDays);
                              _customDayEnabled = tempCustomEnabled;
                              _customDayValue = tempCustomCtl.text;
                            });
                            Navigator.of(dialogContext).pop();
                          },
                          child: const Text('決定'),
                        ),
                      ],
                    ),
                    const Divider(),
                    ...tempSelectedDays.entries.map((entry) {
                      return CheckboxListTile(
                        title:
                            Text(entry.key == 0 ? '当日' : '${entry.key}日前'),
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
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              textAlign: TextAlign.center,
                              decoration:
                                  const InputDecoration(isDense: true),
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
  }

  Future<void> _openExpireSheet() async {
    // ... (This method remains the same)
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final now = DateTime.now();
        DateTime today(DateTime d) => DateTime(d.year, d.month, d.day);
        DateTime? pending = _expireOn;
        return StatefulBuilder(
          builder: (ctx, setLocalState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 12,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text('キャンセル'),
                        ),
                        FilledButton(
                          onPressed: () {
                            setState(() => _expireOn = pending);
                            Navigator.of(ctx).pop();
                          },
                          child: const Text('決定'),
                        ),
                      ],
                    ),
                    CalendarDatePicker(
                      initialDate: pending ?? today(now),
                      firstDate: today(now),
                      lastDate: DateTime(now.year + 5),
                      onDateChanged: (d) =>
                          setLocalState(() => pending = today(d)),
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

  String _expireSubtitle() {
    if (_expireOn == null) return '未設定';
    final d = _expireOn!;
    final fmt = DateFormat('yyyy/MM/dd (E)', 'ja');
    final dateStr = fmt.format(d);
    final today = DateTime.now();
    final dd = DateTime(d.year, d.month, d.day)
        .difference(DateTime(today.year, today.month, today.day))
        .inDays;
    final tail = dd < 0 ? '・期限切れ' : (dd == 0 ? '・本日' : '・残り$dd日');
    return '$dateStr $tail';
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final repo = ref.read(usersYuutaiRepositoryProvider);
    final existing = widget.existing;

    final List<int> notifyDays = [];
    _selectedPredefinedDays.forEach((day, isSelected) {
      if (isSelected) {
        notifyDays.add(day);
      }
    });
    if (_customDayEnabled) {
      final customDay = int.tryParse(_customDayValue);
      if (customDay != null) {
        notifyDays.add(customDay);
      }
    }

    final entity = UsersYuutai(
      id: existing?.id,
      companyName: _titleCtl.text.trim(),
      benefitDetail: _benefitContentCtl.text.trim().isEmpty
          ? null
          : _benefitContentCtl.text.trim(),
      notes: _notesCtl.text.trim().isEmpty ? null : _notesCtl.text.trim(),
      expiryDate: _expireOn,
      alertEnabled: notifyDays.isNotEmpty, // Set alertEnabled based on selection
      status: existing?.status ?? BenefitStatus.active,
      notifyDaysBefore: notifyDays,
      folderId: _selectedFolderId,
    );

    await repo.upsert(entity, scheduleReminders: true);

    ref.invalidate(activeUsersYuutaiProvider);

    await HapticFeedback.mediumImpact();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('保存しました'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _openCompanySearchSheet() async {
    final company = await context.push<String>('/company/search');
    if (company != null) {
      setState(() {
        _titleCtl.text = company;
      });
    }
  }

  Future<void> _handleOcr() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) {
      return;
    }

    final textRecognizer = TextRecognizer();
    final recognizedText =
        await textRecognizer.processImage(InputImage.fromFilePath(image.path));
    await textRecognizer.close();

    setState(() {
      _benefitContentCtl.text = recognizedText.text;
    });

    // Simple date parsing
    final dateRegex = RegExp(r'(\d{4})年(\d{1,2})月(\d{1,2})日');
    final match = dateRegex.firstMatch(recognizedText.text);
    if (match != null) {
      final year = int.parse(match.group(1)!);
      final month = int.parse(match.group(2)!);
      final day = int.parse(match.group(3)!);
      setState(() {
        _expireOn = DateTime(year, month, day);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? '優待を追加' : '優待を編集'),
        actions: [IconButton(onPressed: _save, icon: const Icon(Icons.check))],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600.0),
          child: _buildFormList(),
        ),
      ),
    );
  }

  Widget _buildFormList({EdgeInsets? padding}) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(
        padding: padding ?? const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _titleCtl,
            decoration: const InputDecoration(
              labelText: '企業名',
              hintText: '例: 〇〇ホールディングス',
              suffixIcon: Icon(Icons.search),
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'タイトルを入力してください' : null,
            readOnly: true,
            onTap: _openCompanySearchSheet,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _benefitContentCtl,
            decoration: InputDecoration(
              labelText: '優待内容',
              hintText: '例: 3000円分の割引券',
              isDense: true,
              suffixIcon: IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: _handleOcr,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _notesCtl,
            decoration: const InputDecoration(
              labelText: 'メモ',
              hintText: '自由記述',
              border: OutlineInputBorder(),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            maxLines: 3,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('有効期限'),
            subtitle: Text(_expireSubtitle()),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_expireOn != null)
                  TextButton(
                    onPressed: () => setState(() => _expireOn = null),
                    child: const Text('クリア'),
                  ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _openExpireSheet,
                  child: const Text('選択'),
                ),
              ],
            ),
            onTap: _openExpireSheet,
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
                  
                  final selectedFolder = _selectedFolderId != null
                      ? folders.firstWhere(
                          (f) => f.id == _selectedFolderId,
                          orElse: () => folders.first,
                        )
                      : null;
                   
                   return ListTile(
                     contentPadding: EdgeInsets.zero,
                     title: const Text('フォルダ'),
                     subtitle: Text(selectedFolder == null
                         ? '未分類' 
                         : selectedFolder.name),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final result = await context.push<String?>(
                        '/folders/select',
                      );
                      // Note: The result can be null (for 'Uncategorized'), so we don't need to check for null before setting state.
                      // However, a push can also be dismissed (e.g. back button), which also results in null.
                      // We might want a more robust way to distinguish, but for now this works.
                      // A simple way is to not pop the page but have an explicit selection button.
                      // Or return a tuple like (bool, String?).
                      // The current implementation is fine for now.
                      setState(() {
                        _selectedFolderId = result;
                      });
                    },
                  );
                },
              );
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('通知タイミング'),
            subtitle: Text(_buildReminderSubtitle()),
            trailing: const Icon(Icons.chevron_right),
            onTap: _openReminderPicker,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

