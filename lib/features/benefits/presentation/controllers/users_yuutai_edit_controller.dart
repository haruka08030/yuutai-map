import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/core/ocr/ocr_service.dart';
import 'package:flutter_stock/domain/entities/benefit_status.dart';
import 'package:flutter_stock/domain/entities/users_yuutai.dart';
import 'package:flutter_stock/features/benefits/provider/users_yuutai_providers.dart';
import 'package:flutter_stock/core/exceptions/app_exception.dart';
import 'package:flutter_stock/features/settings/data/notification_settings_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';

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

final titleControllerProvider = Provider.autoDispose.family<TextEditingController, UsersYuutai?>((ref, arg) {
  final controller = TextEditingController(text: arg?.companyName ?? '');
  ref.onDispose(() => controller.dispose());
  return controller;
});
final benefitContentControllerProvider = Provider.autoDispose.family<TextEditingController, UsersYuutai?>((ref, arg) {
  final controller = TextEditingController(text: arg?.benefitDetail ?? '');
  ref.onDispose(() => controller.dispose());
  return controller;
});
final notesControllerProvider = Provider.autoDispose.family<TextEditingController, UsersYuutai?>((ref, arg) {
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

  void updateReminderSettings(Map<int, bool> predefined, bool customDayEnabled, String customDayValue) {
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
      final title = ref.read(titleControllerProvider(state.initialBenefit)).text.trim();
      final benefitContent = ref.read(benefitContentControllerProvider(state.initialBenefit)).text.trim();
      final notes = ref.read(notesControllerProvider(state.initialBenefit)).text.trim();

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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('保存しました')),
        );
        context.pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppException.from(e).message)),
        );
      }
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> handleOcr() async {
    final result = await _ocrService.pickAndRecognizeText();
    if (result == null) return;

    ref.read(benefitContentControllerProvider(state.initialBenefit)).text = result.text;
    if (result.expiryDate != null) {
      state = state.copyWith(expireOn: result.expiryDate);
    }
  }

  void setCompanyName(String name) {
    ref.read(titleControllerProvider(state.initialBenefit)).text = name;
  }
}

final usersYuutaiEditControllerProvider =
    NotifierProvider.autoDispose.family<UsersYuutaiEditController, UsersYuutaiEditState, UsersYuutai?>(
        UsersYuutaiEditController.new);