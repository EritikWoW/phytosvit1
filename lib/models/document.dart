import 'package:json_annotation/json_annotation.dart';
import 'package:phytosvit/models/scan_item.dart';

part 'document.g.dart';

@JsonSerializable(explicitToJson: true)
class Document {
  final int id;
  final String date;
  final int subdivisionId;
  final int documentTypeId;
  final List<ScanItem> items;

  Document({
    required this.id,
    required this.date,
    required this.subdivisionId,
    required this.documentTypeId,
    required this.items,
  });

  /// Создание объекта Document из Map (например, для работы с локальной БД)
  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      id: map['id'] as int,
      date: map['date'] as String,
      subdivisionId: map['subdivision_id'] as int,
      documentTypeId: map['type_id'] as int,
      items: map['items'] as List<ScanItem>,
    );
  }

  /// Преобразование объекта Document в Map
  Map<String, dynamic> toMap() {
    return {
      //'id': id,
      'date': date,
      'subdivision_id': subdivisionId,
      'type_id': documentTypeId,
      //'items': items.map((item) => item.toMap()).toList(),
    };
  }

  /// Создание объекта Document из JSON-данных (сгенерировано json_serializable)
  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);

  /// Преобразование объекта Document в JSON-формат (сгенерировано json_serializable)
  Map<String, dynamic> toJson() => _$DocumentToJson(this);
}
