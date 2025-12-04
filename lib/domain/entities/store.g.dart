// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Store _$StoreFromJson(Map<String, dynamic> json) => _Store(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  latitude: (json['lat'] as num).toDouble(),
  longitude: (json['lng'] as num).toDouble(),
);

Map<String, dynamic> _$StoreToJson(_Store instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'lat': instance.latitude,
  'lng': instance.longitude,
};
