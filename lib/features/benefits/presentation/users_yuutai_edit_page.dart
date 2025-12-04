import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stock/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/domain/entities/benefit_status.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/app/routing/slide_right_route.dart';
import 'package:flutter_stock/features/benefits/presentation/company_search_page.dart';
import 'package:intl/intl.dart';

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
  late final TextEditingController _customDayCtl;

  DateTime? _expireOn;
  bool _alertEnabled = false;

  // New state for multi-select notifications
  final Map<int, bool> _predefinedDays = {
    30: false,
    7: false,
    0: false, // For "On the day"
  };
  bool _customDayEnabled = false;

  @override
  void initState() {
    super.initState();
    _titleCtl = TextEditingController(text: widget.existing?.companyName ?? '');
    _benefitContentCtl =
        TextEditingController(text: widget.existing?.benefitDetail ?? '');
    _notesCtl = TextEditingController(text: widget.existing?.notes ?? '');
    _expireOn = widget.existing?.expiryDate?.toLocal();
    _alertEnabled = widget.existing?.alertEnabled ?? false;
    _customDayCtl = TextEditingController();

    // Initialize notification days state from existing data
    final existingDays = widget.existing?.notifyDaysBefore ?? [7]; // Default to 7
    for (final day in existingDays) {
      if (_predefinedDays.containsKey(day)) {
        _predefinedDays[day] = true;
      } else {
        _customDayEnabled = true;
        _customDayCtl.text = day.toString();
      }
    }
  }

  @override
  void dispose() {
    _titleCtl.dispose();
    _benefitContentCtl.dispose();
    _notesCtl.dispose();
    _customDayCtl.dispose();
    super.dispose();
  }

  Future<void> _openExpireSheet() async {
    // ... (This method remains the same)
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final now = DateTime.now();
        DateTime today(DateTime d) => DateTime(d.year, d.month, d.day);
        DateTime? pending = _expireOn;
        return StatefulBuilder(
          builder: (ctx, setLocalState) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 12,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text('キャンセル'),
                        ),
                        const SizedBox(width: 4),
                        FilledButton(
                          onPressed: () {
                            setState(() => _expireOn = pending);
                            Navigator.of(ctx).pop();
                          },
                          child: const Text('決定'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
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
    final dd = DateTime(
      d.year,
      d.month,
      d.day,
    ).difference(DateTime(today.year, today.month, today.day)).inDays;
    final tail = dd < 0
        ? '・期限切れ'
        : dd == 0
            ? '・本日'
            : '・残り$dd日';
    return '$dateStr $tail';
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final repo = ref.read(usersYuutaiRepositoryProvider);
    final existing = widget.existing;

    // Assemble the list of notification days from the UI state
    final List<int> notifyDays = [];
    _predefinedDays.forEach((day, isSelected) {
      if (isSelected) {
        notifyDays.add(day);
      }
    });
    if (_customDayEnabled) {
      final customDay = int.tryParse(_customDayCtl.text);
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
      alertEnabled: _alertEnabled,
      status: existing?.status ?? BenefitStatus.active,
      notifyDaysBefore: notifyDays, // Use the new list
    );

    await repo.upsert(entity, scheduleReminders: true);
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
    final company = await Navigator.of(context).push<String>(
      SlideRightRoute<String>(page: const CompanySearchPage()),
    );
    if (company != null) {
      setState(() {
        _titleCtl.text = company;
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
      body: _buildFormList(),
    );
  }

  Widget _buildFormList({EdgeInsets? padding}) {
    return Form(
      key: _formKey,
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
            decoration: const InputDecoration(
              labelText: '優待内容',
              hintText: '例: 3000円分の割引券',
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _notesCtl,
            decoration: const InputDecoration(
              labelText: 'メモ',
              hintText: '自由記述',
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
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('リマインダー'),
            trailing: Switch(
              value: _alertEnabled,
              onChanged: (v) => setState(() => _alertEnabled = v),
            ),
            onTap: () => setState(() => _alertEnabled = !_alertEnabled),
          ),
          if (_alertEnabled)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._predefinedDays.entries.map((entry) {
                  return CheckboxListTile(
                    title: Text(entry.key == 0 ? '当日' : '${entry.key}日前'),
                    value: entry.value,
                    onChanged: (bool? value) {
                      setState(() {
                        _predefinedDays[entry.key] = value!;
                      });
                    },
                  );
                }).toList(),
                CheckboxListTile(
                  title: Row(
                    children: [
                      const Text('カスタム:'),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 60,
                        child: TextFormField(
                          controller: _customDayCtl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            isDense: true,
                          ),
                          enabled: _customDayEnabled,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('日前'),
                    ],
                  ),
                  value: _customDayEnabled,
                  onChanged: (bool? value) {
                    setState(() {
                      _customDayEnabled = value!;
                    });
                  },
                ),
              ],
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
