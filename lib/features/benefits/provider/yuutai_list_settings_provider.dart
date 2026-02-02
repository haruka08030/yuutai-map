import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stock/features/benefits/domain/yuutai_list_settings.dart';

class YuutaiListSettingsNotifier extends Notifier<YuutaiListSettings> {
  @override
  YuutaiListSettings build() {
    return const YuutaiListSettings();
  }

  void setSortOrder(YuutaiSortOrder sortOrder) {
    state = state.copyWith(sortOrder: sortOrder);
  }

  void setShowHistory(bool showHistory) {
    state = state.copyWith(showHistory: showHistory);
  }

  void setFolderId(String? folderId) {
    state = state.copyWith(folderId: folderId);
  }

  void setListFilter(YuutaiListFilter listFilter) {
    state = state.copyWith(listFilter: listFilter);
  }

  void reset() {
    state = const YuutaiListSettings();
  }
}

final yuutaiListSettingsProvider =
    NotifierProvider<YuutaiListSettingsNotifier, YuutaiListSettings>(() {
  return YuutaiListSettingsNotifier();
});
