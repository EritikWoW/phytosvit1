// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doc_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocType _$DocTypeFromJson(Map<String, dynamic> json) => DocType(
      id: (json['id'] as num?)?.toInt(),
      typeName: json['type_name'] as String,
    );

Map<String, dynamic> _$DocTypeToJson(DocType instance) => <String, dynamic>{
      'id': instance.id,
      'type_name': instance.typeName,
    };
