import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/core/ocr/ocr_service.dart';
import 'package:flutter_stock/features/benefits/domain/entities/benefit_status.dart';
import 'package:flutter_stock/features/benefits/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/core/exceptions/app_exception.dart';
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
class UsersYuutaiEditState with _$UsersYuutaiEditState {
  const factory UsersYuutaiEditState({
    UsersYuutai? initialBenefit,
    DateTime? expireOn,
    String? selectedFolderId,
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
  final _ocrService = OcrService();

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
      final title = ref
          .read(titleControllerProvider(state.initialBenefit))
          .text
          .trim();
      final benefitContent = ref
          .read(benefitContentControllerProvider(state.initialBenefit))
          .text
          .trim();
      final notes = ref
          .read(notesControllerProvider(state.initialBenefit))
          .text
          .trim();

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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('保存しました')));
        context.pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(AppException.from(e).message)));
      }
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> handleOcr() async {
    final result = await _ocrService.pickAndRecognizeText();
    if (result == null) return;

    ref.read(benefitContentControllerProvider(state.initialBenefit)).text =
        result.text;
    if (result.expiryDate != null) {
      state = state.copyWith(expireOn: result.expiryDate);
    }
  }

  void setCompanyName(String name) {
    ref.read(titleControllerProvider(state.initialBenefit)).text = name;
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
    final company = await context.push<String>('/company/search');
    if (company != null) {
      setCompanyName(company);
    }
  }

  Future<void> selectFolder(BuildContext context) async {
    final result = await context.push<String?>(
      '/folders/select',
    );
    setSelectedFolderId(result);
  }

  Future<void> showReminderPicker(BuildContext context) async {
    final tempSelectedDays = Map<int, bool>.from(
      state.selectedPredefinedDays,
    );
    bool tempCustomEnabled = state.customDayEnabled;
    final tempCustomCtl = TextEditingController(
      text: state.customDayValue,
    );

    try {
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
                              setDialogState(() {
                                tempSelectedDays.updateAll(
                                  (key, value) => false,
                                );
                                tempCustomEnabled = false;
                                tempCustomCtl.clear();
                              });
                            },
                            child: const Text('クリア'),
                          ),
                          FilledButton(
                            onPressed: () {
                              updateReminderSettings(
                                tempSelectedDays,
                                tempCustomEnabled,
                                tempCustomCtl.text,
                              );
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
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  isDense: true,
                                ),
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

final usersYuutaiEditControllerProvider = NotifierProvider.autoDispose
    .family<UsersYuutaiEditController, UsersYuutaiEditState, UsersYuutai?>(
      UsersYuutaiEditController.new,
    );
