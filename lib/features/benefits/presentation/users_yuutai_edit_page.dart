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
  DateTime? _expireOn;
  bool _alertEnabled = false;

  @override
  void initState() {
    super.initState();
    _titleCtl = TextEditingController(text: widget.existing?.companyName ?? '');
    _benefitContentCtl = TextEditingController(
      text: widget.existing?.benefitDetail ?? '',
    );
    _notesCtl = TextEditingController(text: widget.existing?.notes ?? '');
    _expireOn = widget.existing?.expiryDate?.toLocal();
    _alertEnabled = widget.existing?.alertEnabled ?? false;
  }

  @override
  void dispose() {
    _titleCtl.dispose();
    _benefitContentCtl.dispose();
    _notesCtl.dispose();
    super.dispose();
  }

  Future<void> _openExpireSheet() async {
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

    final entity = UsersYuutai(
      id: existing?.id,
      companyName: _titleCtl.text.trim(),
      benefitDetail: _benefitContentCtl.text.trim().isEmpty
          ? null
          : _benefitContentCtl.text.trim(),
      notes:
          _notesCtl.text.trim().isEmpty ? null : _notesCtl.text.trim(),
      expiryDate: _expireOn, // toUtc handled by Supabase/Json? DateTime is usually ISO string.
      alertEnabled: _alertEnabled,
      status: existing?.status ?? BenefitStatus.active,
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
            subtitle: Text(_alertEnabled ? '有効 (7日前)' : '無効'),
            trailing: Switch(
              value: _alertEnabled,
              onChanged: (v) => setState(() => _alertEnabled = v),
            ),
          ),
          const SizedBox(height: 8),
          // Or we may add a "メモ" field.
        ],
      ),
    );
  }
}
