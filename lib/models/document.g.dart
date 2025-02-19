// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Document _$DocumentFromJson(Map<String, dynamic> json) => Document(
      id: (json['id'] as num).toInt(),
      date: json['date'] as String,
      subdivisionId: (json['subdivisionId'] as num).toInt(),
      documentTypeId: (json['documentTypeId'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) => ScanItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DocumentToJson(Document instance) => <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'subdivisionId': instance.subdivisionId,
      'documentTypeId': instance.documentTypeId,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
