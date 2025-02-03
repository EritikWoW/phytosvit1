// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subdivision.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subdivision _$SubdivisionFromJson(Map<String, dynamic> json) => Subdivision(
      id: (json['id'] as num?)?.toInt(),
      subdivisionName: json['subdivision_name'] as String,
    );

Map<String, dynamic> _$SubdivisionToJson(Subdivision instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subdivision_name': instance.subdivisionName,
    };
