// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upc_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item()
  ..ean = json['ean'] as String?
  ..title = json['title'] as String?
  ..description = json['description'] as String?
  ..upc = json['upc'] as String?
  ..brand = json['brand'] as String?
  ..model = json['model'] as String?
  ..color = json['color'] as String?
  ..size = json['size'] as String?
  ..dimension = json['dimension'] as String?
  ..weight = json['weight'] as String?
  ..category = json['category'] as String?
  ..lowestRecordedPrice = (json['lowestRecordedPrice'] as num?)?.toDouble()
  ..highestRecordedPrice = (json['highestRecordedPrice'] as num?)?.toDouble()
  ..images =
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..asin = json['asin'] as String?
  ..elid = json['elid'] as String?;

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'ean': instance.ean,
      'title': instance.title,
      'description': instance.description,
      'upc': instance.upc,
      'brand': instance.brand,
      'model': instance.model,
      'color': instance.color,
      'size': instance.size,
      'dimension': instance.dimension,
      'weight': instance.weight,
      'category': instance.category,
      'lowestRecordedPrice': instance.lowestRecordedPrice,
      'highestRecordedPrice': instance.highestRecordedPrice,
      'images': instance.images,
      'asin': instance.asin,
      'elid': instance.elid,
    };
