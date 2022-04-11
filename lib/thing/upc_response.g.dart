// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upc_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpcResponse _$UpcResponseFromJson(Map<String, dynamic> json) => UpcResponse()
  ..code = json['code'] as String?
  ..total = json['total'] as int?
  ..offset = json['offset'] as int?
  ..items = (json['items'] as List<dynamic>?)
      ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$UpcResponseToJson(UpcResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'total': instance.total,
      'offset': instance.offset,
      'items': instance.items,
    };
