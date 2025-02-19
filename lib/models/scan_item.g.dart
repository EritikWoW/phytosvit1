// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScanItem _$ScanItemFromJson(Map<String, dynamic> json) => ScanItem(
      text: json['text'] as String,
      count: (json['count'] as num).toInt(),
      unitId: (json['unitId'] as num).toInt(),
    );

Map<String, dynamic> _$ScanItemToJson(ScanItem instance) => <String, dynamic>{
      'text': instance.text,
      'count': instance.count,
      'unitId': instance.unitId,
    };
