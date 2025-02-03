import 'package:json_annotation/json_annotation.dart';
import 'package:phytosvit/database/sq_light/units_helper.dart';

part 'unit.g.dart';

@JsonSerializable()
class Unit {
  final int? id;

  @JsonKey(name: 'unit_name') // Для соответствия JSON ключу
  final String unitName;

  Unit({this.id, required this.unitName});

  // Фабричный метод для создания объекта из JSON
  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);

  // Преобразование объекта в JSON
  Map<String, dynamic> toJson() => _$UnitToJson(this);

  // Преобразование объекта в Map для работы с SQLite
  Map<String, dynamic> toMap() {
    return {
      DBUnitsHelperLite.COLUMN_UNIT_ID: id,
      DBUnitsHelperLite.COLUMN_UNIT_NAME: unitName,
    };
  }

  // Создание объекта из Map (для SQLite)
  factory Unit.fromMap(Map<String, dynamic> map) {
    return Unit(
      id: map[DBUnitsHelperLite.COLUMN_UNIT_ID] as int?,
      unitName: map[DBUnitsHelperLite.COLUMN_UNIT_NAME] as String,
    );
  }

  @override
  String toString() {
    return 'Unit{id: $id, unitName: $unitName}';
  }
}
