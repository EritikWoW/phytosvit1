import 'package:json_annotation/json_annotation.dart';
import 'package:phytosvit/database/sq_light/doc_type_helper.dart';

part 'doc_type.g.dart';

@JsonSerializable()
class DocType {
  final int? id;

  @JsonKey(name: 'type_name') // Для соответствия JSON ключу
  final String typeName;

  DocType({this.id, required this.typeName});

  // Фабричный метод для создания объекта из JSON
  factory DocType.fromJson(Map<String, dynamic> json) =>
      _$DocTypeFromJson(json);

  // Преобразование объекта в JSON
  Map<String, dynamic> toJson() => _$DocTypeToJson(this);

  // Преобразование объекта в Map для работы с SQLite
  Map<String, dynamic> toMap() {
    return {
      DBDocTypeHelperLite.COLUMN_DOC_TYPE_ID: id,
      DBDocTypeHelperLite.COLUMN_DOC_TYPE_NAME: typeName,
    };
  }

  // Создание объекта из Map (для SQLite)
  factory DocType.fromMap(Map<String, dynamic> map) {
    return DocType(
      id: map[DBDocTypeHelperLite.COLUMN_DOC_TYPE_ID] as int?,
      typeName: map[DBDocTypeHelperLite.COLUMN_DOC_TYPE_NAME] as String,
    );
  }

  @override
  String toString() {
    return 'DocType{id: $id, typeName: $typeName}';
  }
}
