import 'package:json_annotation/json_annotation.dart';
import 'package:phytosvit/database/sq_light/subdivisions_helper.dart';

part 'subdivision.g.dart';

@JsonSerializable()
class Subdivision {
  final int? id;

  @JsonKey(name: 'subdivision_name')
  final String subdivisionName;

  Subdivision({this.id, required this.subdivisionName});

  // Фабричный метод для создания объекта из JSON
  factory Subdivision.fromJson(Map<String, dynamic> json) =>
      _$SubdivisionFromJson(json);

  // Преобразование объекта в JSON
  Map<String, dynamic> toJson() => _$SubdivisionToJson(this);

  // Преобразование объекта в Map для работы с SQLite
  Map<String, dynamic> toMap() {
    return {
      DBSubdivisionsHelperLite.COLUMN_SUBDIVISION_ID: id,
      DBSubdivisionsHelperLite.COLUMN_SUBDIVISION_NAME: subdivisionName,
    };
  }

  // Создание объекта из Map (для SQLite)
  factory Subdivision.fromMap(Map<String, dynamic> map) {
    return Subdivision(
      id: map[DBSubdivisionsHelperLite.COLUMN_SUBDIVISION_ID] as int?,
      subdivisionName:
          map[DBSubdivisionsHelperLite.COLUMN_SUBDIVISION_NAME] as String,
    );
  }

  @override
  String toString() {
    return 'Subdivision{id: $id, subdivisionName: $subdivisionName}';
  }
}
