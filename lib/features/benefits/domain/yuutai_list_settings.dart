import 'package:freezed_annotation/freezed_annotation.dart';

part 'yuutai_list_settings.freezed.dart';

enum YuutaiSortOrder { expiryDate, companyName, createdAt }

/// 一覧のフィルター種別
enum YuutaiListFilter { all, expiringSoon, active, used }

@freezed
abstract class YuutaiListSettings with _$YuutaiListSettings {
  const factory YuutaiListSettings({
    @Default(YuutaiSortOrder.expiryDate) YuutaiSortOrder sortOrder,
    @Default(false) bool showHistory,
    @Default(YuutaiListFilter.all) YuutaiListFilter listFilter,
    String? folderId,
  }) = _YuutaiListSettings;
}
