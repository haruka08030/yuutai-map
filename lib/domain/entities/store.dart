import 'package:freezed_annotation/freezed_annotation.dart';

part 'store.freezed.dart';
part 'store.g.dart';

@freezed
abstract class Store with _$Store {
  const factory Store({
    required int id,
    required String name,
    @JsonKey(name: 'lat') required double latitude,
    @JsonKey(name: 'lng') required double longitude,
    @JsonKey(name: 'category_tag') String? category,
    String? address,
    @JsonKey(name: 'company_id') int? companyId,
  }) = _Store;

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
}
