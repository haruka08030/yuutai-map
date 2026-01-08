import 'package:freezed_annotation/freezed_annotation.dart';

part 'yuutai_list_settings.freezed.dart';

enum YuutaiSortOrder { expiryDate, companyName, createdAt }

@freezed
class YuutaiListSettings with _$YuutaiListSettings {
  const factory YuutaiListSettings({
    @Default(YuutaiSortOrder.expiryDate) YuutaiSortOrder sortOrder,
    @Default(false) bool showHistory,
    String? folderId,
  }) = _YuutaiListSettings;
}
