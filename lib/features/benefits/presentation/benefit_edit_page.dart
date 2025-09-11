import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stock/domain/entities/user_benefit.dart';
import 'package:flutter_stock/features/benefits/provider/benefit_providers.dart';
import 'package:intl/intl.dart';

class BenefitEditPage extends ConsumerStatefulWidget {
  const BenefitEditPage({super.key, this.existing, this.asSheet = false});
  final UserBenefit? existing;
  final bool asSheet;

  @override
  ConsumerState<BenefitEditPage> createState() => _BenefitEditPageState();
}

class _BenefitEditPageState extends ConsumerState<BenefitEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtl;
  late final TextEditingController _benefitContentCtl;
  late final TextEditingController _memoCtl;
  DateTime? _expireOn;
  int? _notifyBeforeDays;

  InputDecoration _underlineDecoration(String label, String hint) {
    final scheme = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: label,
      hintText: hint,
      isDense: true,
      // compact paddings and label sizes to reduce height
      contentPadding: const EdgeInsets.symmetric(vertical: 6),
      labelStyle: TextStyle(
        fontSize: 15,
        color: Theme.of(context).textTheme.bodySmall?.color,
      ),
      floatingLabelStyle: TextStyle(fontSize: 13, color: scheme.primary),
      hintStyle: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(color: scheme.outline),
      filled: false,
      border: const UnderlineInputBorder(),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: scheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: scheme.primary, width: 1.6),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _titleCtl = TextEditingController(text: widget.existing?.title ?? '');
    _benefitContentCtl = TextEditingController(
      text: widget.existing?.benefitText ?? '',
    );
    _memoCtl = TextEditingController(text: widget.existing?.notes ?? '');
    _expireOn = widget.existing?.expireOn;
    _notifyBeforeDays = widget.existing?.notifyBeforeDays;
  }

  @override
  void dispose() {
    _titleCtl.dispose();
    _benefitContentCtl.dispose();
    _memoCtl.dispose();
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

  int _bitForDay(int d) {
    switch (d) {
      case 0:
        return 1 << 0;
      case 1:
        return 1 << 1;
      case 7:
        return 1 << 2;
      case 30:
        return 1 << 3;
      default:
        return 0;
    }
  }

  Set<int> _decodeDays(int? v) {
    if (v == null) {
      return {30, 7, 1, 0};
    }
    if (v > 15 && v != 30 && v != 7 && v != 1 && v != 0) {
      return {v}; // custom single value
    }
    if (v == 0 || v == 1 || v == 7 || v == 30) {
      return {v};
    }
    final set = <int>{};
    for (final d in const [0, 1, 7, 30]) {
      if ((v & _bitForDay(d)) != 0) {
        set.add(d);
      }
    }
    return set;
  }

  Future<void> _pickReminderOffset() async {
    final initialPreset = _decodeDays(_notifyBeforeDays);
    final Set<int> pending = {...initialPreset};
    int? custom;
    final vInit = _notifyBeforeDays;
    if (vInit != null) {
      if (vInit >= 1000) {
        custom = vInit ~/ 1000;
      } else if (vInit > 15 && !{0, 1, 7, 30}.contains(vInit)) {
        custom = vInit; // legacy custom single
      }
    }

    Future<int?> askCustomDays(BuildContext ctx, {int? initial}) async {
      final ctl = TextEditingController(text: (initial ?? 3).toString());
      final picked = await showDialog<int?>(
        context: ctx,
        builder: (dctx) => AlertDialog(
          title: const Text('カスタム日数を入力'),
          content: TextField(
            controller: ctl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: '例: 14 (日)'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dctx, null),
              child: const Text('キャンセル'),
            ),
            FilledButton(
              onPressed: () {
                final n = int.tryParse(ctl.text.trim());
                Navigator.pop(dctx, n);
              },
              child: const Text('決定'),
            ),
          ],
        ),
      );
      if (picked == null) return null;
      if (picked < 0) return null;
      return picked;
    }

    int? encode(Set<int> days, int? custom) {
      final hasPresets = days.isNotEmpty;
      final hasCustom = custom != null;
      if (!hasPresets && !hasCustom) return null; // 通知なし
      var mask = 0;
      for (final d in days) {
        mask |= _bitForDay(d);
      }
      if (hasCustom) return custom * 1000 + mask; // 追加方式
      return mask;
    }

    final result = await showModalBottomSheet<int?>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: StatefulBuilder(
          builder: (ctx, setLocal) {
            Widget tile(String label, int day) {
              final checked = pending.contains(day);
              return ListTile(
                title: Text(label),
                trailing: checked ? const Icon(Icons.check) : null,
                onTap: () => setLocal(() {
                  if (checked) {
                    pending.remove(day);
                  } else {
                    pending.add(day);
                  }
                }),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(null),
                        child: const Text('キャンセル'),
                      ),
                      const SizedBox(width: 4),
                      FilledButton(
                        onPressed: () =>
                            Navigator.of(ctx).pop(encode(pending, custom)),
                        child: const Text('決定'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ListTile(
                    title: const Text('通知なし'),
                    trailing: (pending.isEmpty && custom == null)
                        ? const Icon(Icons.check)
                        : null,
                    onTap: () => setLocal(() {
                      pending.clear();
                      custom = null;
                    }),
                  ),
                  tile('30日前', 30),
                  tile('7日前', 7),
                  tile('1日前', 1),
                  tile('当日', 0),
                  const Divider(height: 12),
                  ListTile(
                    leading: const Icon(Icons.tune),
                    title: Text(custom == null ? 'カスタムを追加' : 'カスタム: $custom日前'),
                    trailing: custom != null ? const Icon(Icons.check) : null,
                    onTap: () async {
                      final v = await askCustomDays(ctx, initial: custom);
                      // 空欄やキャンセルなら選択解除
                      setLocal(() => custom = v);
                    },
                    onLongPress: () => setLocal(() => custom = null),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        ),
      ),
    );

    if (result == null) {
      setState(() => _notifyBeforeDays = null);
    } else {
      setState(() => _notifyBeforeDays = result);
    }
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final repo = ref.read(userBenefitRepositoryProvider);
    final existing = widget.existing;

    final entity = UserBenefit(
      id: existing?.id ?? '',
      title: _titleCtl.text.trim(),
      benefitText: _benefitContentCtl.text.trim().isEmpty
          ? null
          : _benefitContentCtl.text.trim(),
      notes: _memoCtl.text.trim().isEmpty ? null : _memoCtl.text.trim(),
      expireOn: _expireOn,
      notifyBeforeDays: _notifyBeforeDays,
      isUsed: existing?.isUsed ?? false,
    );

    try {
      await repo.upsert(entity, scheduleReminders: true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('保存に失敗しました: $e'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    await HapticFeedback.mediumImpact();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('保存しました'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );

    // 成功チェックのポップアップを表示（非同期で自己クローズ）
    // NOTE: ここでawaitしない。遅延で明示的に閉じる。
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'success',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (ctx, a1, a2) {
        return Center(
          child: AnimatedScale(
            duration: const Duration(milliseconds: 150),
            scale: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surface.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    color: Colors.black.withValues(alpha: 0.15),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 48,
              ),
            ),
          ),
        );
      },
    );

    // 少し見せてから自動で閉じる→ホームへ戻る
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    // ダイアログを閉じる（rootNavigatorに積まれるためtrue指定）
    Navigator.of(context, rootNavigator: true).pop();
    if (!mounted) return;
    if (widget.asSheet) {
      // シートを閉じる（一覧はStreamで自動更新）
      Navigator.of(context).pop();
    } else {
      // 画面遷移から来た場合はホームへ
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.asSheet) {
      // 下からのモーダル用UI
      final bottom = MediaQuery.of(context).viewInsets.bottom;
      return Padding(
        padding: EdgeInsets.only(bottom: bottom),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  const Spacer(),
                  IconButton(
                    onPressed: _save,
                    icon: const Icon(Icons.check),
                    tooltip: '保存',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Expanded(
              child: _buildFormList(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? '優待を追加' : '優待を編集'),
        actions: [IconButton(onPressed: _save, icon: const Icon(Icons.save))],
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
            style: const TextStyle(fontSize: 16, height: 1.2),
            decoration: _underlineDecoration('企業名', '例: 〇〇ホールディングス'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'タイトルを入力してください' : null,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _benefitContentCtl,
            style: const TextStyle(fontSize: 15, height: 1.2),
            decoration: _underlineDecoration('優待内容', '例: 3000円分の割引券'),
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
            subtitle: Text(() {
              final v = _notifyBeforeDays;
              if (v == null) return '通知なし';
              final days = _decodeDays(v).toList()
                ..sort((a, b) => b.compareTo(a));
              int? custom;
              if (v >= 1000) {
                custom = v ~/ 1000;
              } else if (v > 15 && !{0, 1, 7, 30}.contains(v)) {
                custom = v; // legacy
              }
              final labels = <String>[
                ...days.map((d) => d == 0 ? '当日' : '$d日前'),
                if (custom != null) '$custom日前',
              ];
              if (labels.isEmpty) return '通知なし';
              return labels.join(', ');
            }()),
            trailing: TextButton(
              onPressed: _pickReminderOffset,
              child: const Text('選択'),
            ),
            onTap: _pickReminderOffset,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 4),
            child: Text(
              'メモ',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(
                  context,
                ).textTheme.bodySmall?.color?.withValues(alpha: 0.8),
              ),
            ),
          ),
          TextFormField(
            controller: _memoCtl,
            decoration: const InputDecoration(
              hintText: '自由に記入できます',
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
