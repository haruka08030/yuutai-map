import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stock/domain/entities/user_benefit.dart';
import 'package:flutter_stock/features/benefits/provider/benefit_providers.dart';
import 'package:intl/intl.dart';

class BenefitEditPage extends ConsumerStatefulWidget {
  const BenefitEditPage({super.key, this.existing, this.asSheet = false});
  final UserBenefit? existing;
  final bool asSheet; // 下から出るシート表示用

  @override
  ConsumerState<BenefitEditPage> createState() => _BenefitEditPageState();
}

class _BenefitEditPageState extends ConsumerState<BenefitEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtl;
  late final TextEditingController _benefitContentCtl; // 優待内容（3000円分など）
  late final TextEditingController _memoCtl; // 自由記入メモ
  DateTime? _expireOn;

  @override
  void initState() {
    super.initState();
    _titleCtl = TextEditingController(text: widget.existing?.title ?? '');
    _benefitContentCtl = TextEditingController(
      text: widget.existing?.benefitText ?? '',
    );
    _memoCtl = TextEditingController(text: widget.existing?.notes ?? '');
    _expireOn = widget.existing?.expireOn;
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
        DateTime endOfMonth(DateTime d) => DateTime(d.year, d.month + 1, 0);
        DateTime? pending = _expireOn;
        return StatefulBuilder(
          builder: (ctx, setLocalState) {
            final choices = <(String, DateTime?)>[
              ('未設定にする', null),
              ('今日', today(now)),
              ('明日', today(now).add(const Duration(days: 1))),
              ('7日後', today(now).add(const Duration(days: 7))),
              ('今月末', endOfMonth(now)),
            ];

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
                        Text(
                          '有効期限を選択',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
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
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final c in choices)
                          ChoiceChip(
                            label: Text(c.$1),
                            selected:
                                (pending == null && c.$2 == null) ||
                                (pending != null &&
                                    c.$2 != null &&
                                    today(pending!) == today(c.$2!)),
                            onSelected: (_) =>
                                setLocalState(() => pending = c.$2),
                          ),
                      ],
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
    final repo = ref.read(userBenefitRepositoryProvider);
    final existing = widget.existing;

    final entity = UserBenefit(
      id: existing?.id ?? '',
      title: _titleCtl.text.trim(),
      // 優待内容は benefitText へ保存
      benefitText: _benefitContentCtl.text.trim().isEmpty
          ? null
          : _benefitContentCtl.text.trim(),
      // メモは notes へ保存
      notes: _memoCtl.text.trim().isEmpty ? null : _memoCtl.text.trim(),
      expireOn: _expireOn,
      isUsed: existing?.isUsed ?? false,
    );

    await repo.upsert(entity, scheduleReminders: true);
    // Haptics + toast + mini check overlay
    await HapticFeedback.mediumImpact();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('保存しました'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );

    // 成功アイコンの軽いオーバーレイを表示
    await showGeneralDialog(
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
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 48,
              ),
            ),
          ),
        );
      },
    );

    await Future.delayed(const Duration(milliseconds: 350));
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop(); // close overlay
    }
    if (mounted) {
      Navigator.of(context).pop(); // close sheet/page
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
            const SizedBox(height: 4),
            Expanded(child: _buildFormList()),
          ],
        ),
      );
    }

    // 通常のフルスクリーンページ
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? '優待を追加' : '優待を編集'),
        actions: [IconButton(onPressed: _save, icon: const Icon(Icons.save))],
      ),
      body: _buildFormList(),
    );
  }

  Widget _buildFormList() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _titleCtl,
            decoration: const InputDecoration(
              labelText: '企業名',
              hintText: '例: 〇〇ホールディングス',
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'タイトルを入力してください' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _benefitContentCtl,
            decoration: const InputDecoration(
              labelText: '優待内容',
              hintText: '例: 3000円分の割引券',
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
          // ラベルは上部に小さく固定表示
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
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('有効期限'),
            subtitle: Text(_expireSubtitle()),
            trailing: TextButton(
              onPressed: _openExpireSheet,
              child: const Text('選択'),
            ),
            onTap: _openExpireSheet,
          ),
          if (_expireOn != null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => setState(() => _expireOn = null),
                child: const Text('クリア'),
              ),
            ),
          // 下部の保存ボタンは不要（上部チェックで保存）
        ],
      ),
    );
  }
}
