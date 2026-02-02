import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_stock/features/benefits/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/features/benefits/presentation/controllers/users_yuutai_edit_controller.dart';
import 'package:flutter_stock/features/benefits/presentation/widgets/users_yuutai_form.dart';

/// 優待の追加・編集を下から約半分の高さで表示するシート。追加時は existing: null。
class YuutaiEditSheet extends HookConsumerWidget {
  const YuutaiEditSheet({super.key, this.existing});

  final UsersYuutai? existing;

  /// 追加・編集シートを表示する。追加は existing: null、編集は existing: 対象の優待。
  static void show(BuildContext context, {UsersYuutai? existing}) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.55,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withValues(
                    alpha: 0.12,
                  ),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: YuutaiEditSheet(existing: existing),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final controller = ref.watch(usersYuutaiEditControllerProvider(existing));
    final notifier = ref.read(
      usersYuutaiEditControllerProvider(existing).notifier,
    );
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // ドラッグハンドル（モダンなピル型）
          Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 12),
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                const Spacer(),
                // 期限（有効期限ピッカー）
                IconButton(
                  onPressed: () => notifier.showExpiryPicker(context),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: colorScheme.onSurfaceVariant,
                  ),
                  icon: const Icon(Icons.calendar_today_rounded, size: 24),
                  tooltip: '有効期限',
                ),
                // 通知（リマインダーピッカー）
                IconButton(
                  onPressed: () => notifier.showReminderPicker(context),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: colorScheme.onSurfaceVariant,
                  ),
                  icon: const Icon(Icons.notifications_outlined, size: 24),
                  tooltip: '通知タイミング',
                ),
                if (controller.isLoading)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.primary,
                      ),
                    ),
                  )
                else
                  IconButton(
                    onPressed: () => notifier.save(context, formKey),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: colorScheme.primary,
                    ),
                    icon: const Icon(Icons.check_rounded, size: 24),
                    tooltip: '保存',
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // フォーム（ListView でスクロール）
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: UsersYuutaiForm(
                  existing: existing,
                  formKey: formKey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
