import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_stock/features/benefits/domain/entities/benefit_status.dart';
import 'package:flutter_stock/features/benefits/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/core/utils/snackbar_utils.dart';
import 'package:flutter_stock/features/benefits/domain/entities/company_search_item.dart';
import 'package:flutter_stock/features/benefits/presentation/company_search_page.dart';
import 'package:flutter_stock/features/folders/presentation/folder_selection_page.dart';
import 'package:flutter_stock/features/benefits/presentation/widgets/save_success_card_overlay.dart';
import 'package:flutter_stock/features/settings/data/notification_settings_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

part 'users_yuutai_edit_controller.freezed.dart';

const Map<int, bool> _predefinedDayOptions = {
  30: false,
  7: false,
  3: false,
  1: false,
  0: false,
};

@freezed
abstract class UsersYuutaiEditState with _$UsersYuutaiEditState {
  const factory UsersYuutaiEditState({
    UsersYuutai? initialBenefit,
    DateTime? expireOn,
    String? selectedFolderId,
    int? selectedCompanyId,
    @Default(_predefinedDayOptions) Map<int, bool> selectedPredefinedDays,
    @Default(false) bool customDayEnabled,
    @Default('') String customDayValue,
    @Default(false) bool isLoading,
  }) = _UsersYuutaiEditState;
}

final titleControllerProvider = Provider.autoDispose
    .family<TextEditingController, UsersYuutai?>((ref, arg) {
  final controller = TextEditingController(text: arg?.companyName ?? '');
  ref.onDispose(() => controller.dispose());
  return controller;
});
final benefitContentControllerProvider = Provider.autoDispose
    .family<TextEditingController, UsersYuutai?>((ref, arg) {
  final controller = TextEditingController(text: arg?.benefitDetail ?? '');
  ref.onDispose(() => controller.dispose());
  return controller;
});
final notesControllerProvider = Provider.autoDispose
    .family<TextEditingController, UsersYuutai?>((ref, arg) {
  final controller = TextEditingController(text: arg?.notes ?? '');
  ref.onDispose(() => controller.dispose());
  return controller;
});

class UsersYuutaiEditController extends Notifier<UsersYuutaiEditState> {
  UsersYuutaiEditController(this.initialBenefit);

  final UsersYuutai? initialBenefit;

  @override
  UsersYuutaiEditState build() {
    final Map<int, bool> selectedDays = Map.from(_predefinedDayOptions);
    bool customEnabled = false;
    String customValue = '';

    if (initialBenefit == null) {
      final defaultDays = ref.watch(defaultNotifyDaysProvider);
      for (final day in defaultDays) {
        if (selectedDays.containsKey(day)) {
          selectedDays[day] = true;
        } else {
          customEnabled = true;
          customValue = day.toString();
        }
      }
    } else {
      final existingDays = initialBenefit?.notifyDaysBefore ?? [];
      if (initialBenefit?.alertEnabled == true && existingDays.isNotEmpty) {
        for (final day in existingDays) {
          if (selectedDays.containsKey(day)) {
            selectedDays[day] = true;
          } else {
            customEnabled = true;
            customValue = day.toString();
          }
        }
      }
    }

    return UsersYuutaiEditState(
      initialBenefit: initialBenefit,
      expireOn: initialBenefit?.expiryDate?.toLocal(),
      selectedFolderId: initialBenefit?.folderId,
      selectedCompanyId: initialBenefit?.companyId,
      selectedPredefinedDays: selectedDays,
      customDayEnabled: customEnabled,
      customDayValue: customValue,
    );
  }

  void setExpireOn(DateTime? date) {
    state = state.copyWith(expireOn: date);
  }

  void setSelectedFolderId(String? id) {
    state = state.copyWith(selectedFolderId: id);
  }

  void updateReminderSettings(
    Map<int, bool> predefined,
    bool customDayEnabled,
    String customDayValue,
  ) {
    state = state.copyWith(
      selectedPredefinedDays: predefined,
      customDayEnabled: customDayEnabled,
      customDayValue: customDayValue,
    );
  }

  Future<void> save(BuildContext context, GlobalKey<FormState> formKey) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    state = state.copyWith(isLoading: true);

    try {
      final repo = ref.read(usersYuutaiRepositoryProvider);
      final title =
          ref.read(titleControllerProvider(state.initialBenefit)).text.trim();
      final benefitContent = ref
          .read(benefitContentControllerProvider(state.initialBenefit))
          .text
          .trim();
      final notes =
          ref.read(notesControllerProvider(state.initialBenefit)).text.trim();

      final List<int> notifyDays = [];
      state.selectedPredefinedDays.forEach((day, isSelected) {
        if (isSelected) {
          notifyDays.add(day);
        }
      });
      if (state.customDayEnabled) {
        final customDay = int.tryParse(state.customDayValue);
        if (customDay != null) {
          notifyDays.add(customDay);
        }
      }

      final entity = UsersYuutai(
        id: state.initialBenefit?.id,
        companyId: state.selectedCompanyId ?? state.initialBenefit?.companyId,
        companyName: title,
        benefitDetail: benefitContent.isEmpty ? null : benefitContent,
        notes: notes.isEmpty ? null : notes,
        expiryDate: state.expireOn,
        alertEnabled: notifyDays.isNotEmpty,
        status: state.initialBenefit?.status ?? BenefitStatus.active,
        notifyDaysBefore: notifyDays,
        folderId: state.selectedFolderId,
      );

      await repo.upsert(entity, scheduleReminders: true);
      ref.invalidate(activeUsersYuutaiProvider);
      if (context.mounted) {
        showSaveSuccessCardOverlay(context, onComplete: () {
          if (context.mounted) context.pop();
        });
      }
    } catch (e) {
      if (context.mounted) showErrorSnackBar(context, e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void setCompanyName(String name) {
    ref.read(titleControllerProvider(state.initialBenefit)).text = name;
  }

  void setCompanyId(int? id) {
    state = state.copyWith(selectedCompanyId: id);
  }

  Future<void> showExpiryPicker(BuildContext context) async {
    final now = DateTime.now();
    DateTime today(DateTime d) => DateTime(d.year, d.month, d.day);
    DateTime? pending = state.expireOn;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
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
                            setExpireOn(pending);
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

  Future<void> selectCompany(BuildContext context) async {
    // Push with Navigator to avoid go_router duplicate page key when opening
    // from /yuutai/add (outside shell) to /yuutai/company/search (inside shell).
    final company = await Navigator.of(context).push<CompanySearchItem>(
      PageRouteBuilder<CompanySearchItem>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const CompanySearchPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
    if (company != null) {
      setCompanyName(company.name);
      setCompanyId(company.id == 0 ? null : company.id);
    }
  }

  Future<void> selectFolder(BuildContext context) async {
    final result = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        decoration: BoxDecoration(
          color: Theme.of(sheetContext).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: const FolderSelectionSheetContent(),
      ),
    );
    setSelectedFolderId(result);
  }

  Future<void> showReminderPicker(BuildContext context) async {
    final initialDays = Map<int, bool>.from(state.selectedPredefinedDays);
    final initialCustomEnabled = state.customDayEnabled;
    final initialCustomValue = state.customDayValue;

    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (dialogContext) => _ReminderPickerDialog(
        initialSelectedDays: initialDays,
        initialCustomEnabled: initialCustomEnabled,
        initialCustomValue: initialCustomValue,
        onConfirm: (
          selectedDays,
          customEnabled,
          customValue,
        ) {
          updateReminderSettings(selectedDays, customEnabled, customValue);
        },
      ),
    );
  }
}

class _ReminderPickerDialog extends StatefulWidget {
  const _ReminderPickerDialog({
    required this.initialSelectedDays,
    required this.initialCustomEnabled,
    required this.initialCustomValue,
    required this.onConfirm,
  });

  final Map<int, bool> initialSelectedDays;
  final bool initialCustomEnabled;
  final String initialCustomValue;
  final void Function(
    Map<int, bool> selectedDays,
    bool customEnabled,
    String customValue,
  ) onConfirm;

  @override
  State<_ReminderPickerDialog> createState() => _ReminderPickerDialogState();
}

class _ReminderPickerDialogState extends State<_ReminderPickerDialog> {
  late Map<int, bool> _selectedDays;
  late bool _customEnabled;
  late TextEditingController _customCtl;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _selectedDays = Map<int, bool>.from(widget.initialSelectedDays);
    _customEnabled = widget.initialCustomEnabled;
    _customCtl = TextEditingController(text: widget.initialCustomValue);
  }

  @override
  void dispose() {
    _customCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._selectedDays.entries.map((entry) {
              return CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  entry.key == 0 ? '当日' : '${entry.key}日前',
                ),
                value: entry.value,
                onChanged: (bool? value) {
                  setState(() {
                    _selectedDays[entry.key] = value!;
                  });
                },
              );
            }),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  const Text('カスタム:'),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 56,
                    child: TextFormField(
                      controller: _customCtl,
                      onChanged: (_) {
                        if (_validationError != null) {
                          setState(() => _validationError = null);
                        }
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                      ),
                      enabled: _customEnabled,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text('日前'),
                ],
              ),
              value: _customEnabled,
              onChanged: (bool? value) {
                setState(() {
                  _customEnabled = value!;
                  _validationError = null;
                });
              },
            ),
            if (_validationError != null) ...[
              const SizedBox(height: 8),
              Text(
                _validationError!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _selectedDays.updateAll((key, value) => false);
              _customEnabled = false;
              _customCtl.clear();
            });
          },
          child: const Text('クリア'),
        ),
        FilledButton(
          onPressed: () {
            if (_customEnabled && _customCtl.text.trim().isEmpty) {
              setState(() {
                _validationError = 'カスタムを選択した場合は日数を入力してください';
              });
              return;
            }
            widget.onConfirm(
              _selectedDays,
              _customEnabled,
              _customCtl.text,
            );
            Navigator.of(context).pop();
          },
          child: const Text('決定'),
        ),
      ],
    );
  }
}

final usersYuutaiEditControllerProvider = NotifierProvider.autoDispose
    .family<UsersYuutaiEditController, UsersYuutaiEditState, UsersYuutai?>(
  UsersYuutaiEditController.new,
);
