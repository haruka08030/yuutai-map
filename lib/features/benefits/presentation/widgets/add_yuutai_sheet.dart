import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_stock/features/benefits/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/features/benefits/presentation/controllers/users_yuutai_edit_controller.dart';
import 'package:flutter_stock/features/benefits/presentation/widgets/users_yuutai_form.dart';

bool _hasReminderSet(UsersYuutaiEditState state) {
  final anyPredefined =
      state.selectedPredefinedDays.values.any((selected) => selected);
  final hasCustom =
      state.customDayEnabled && state.customDayValue.trim().isNotEmpty;
  return anyPredefined || hasCustom;
}

/// 期限表示: 当年は MM/dd、翌年以降は yyyy/MM/dd（1桁は0埋め）
String _formatExpiryLabel(DateTime date) {
  final now = DateTime.now();
  if (date.year == now.year) {
    return DateFormat('MM/dd', 'ja').format(date);
  }
  return DateFormat('yyyy/MM/dd', 'ja').format(date);
}

class YuutaiEditSheet extends HookConsumerWidget {
  const YuutaiEditSheet({super.key, this.existing});

  final UsersYuutai? existing;

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
                InkWell(
                  onTap: () => notifier.showExpiryPicker(context),
                  borderRadius: BorderRadius.circular(24),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 24,
                          color: controller.expireOn != null
                              ? colorScheme.secondary
                              : colorScheme.onSurfaceVariant,
                        ),
                        if (controller.expireOn != null) ...[
                          const SizedBox(width: 4),
                          Text(
                            _formatExpiryLabel(controller.expireOn!),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => notifier.showReminderPicker(context),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: _hasReminderSet(controller)
                        ? colorScheme.secondary
                        : colorScheme.onSurfaceVariant,
                  ),
                  icon: Icon(
                    _hasReminderSet(controller)
                        ? Icons.notifications_active
                        : Icons.notifications_outlined,
                    size: 24,
                  ),
                  tooltip: '通知タイミング',
                ),
                const Spacer(),
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
