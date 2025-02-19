import 'package:json_annotation/json_annotation.dart';

part 'scan_item.g.dart';

@JsonSerializable()
class ScanItem {
  String text;
  int count;
  int unitId;

  ScanItem({
    required this.text,
    required this.count,
    required this.unitId,
  });

  /// Фабричный конструктор для создания объекта из JSON, сгенерированный json_serializable
  factory ScanItem.fromJson(Map<String, dynamic> json) =>
      _$ScanItemFromJson(json);

  /// Преобразование объекта в JSON-формат, сгенерированный json_serializable
  Map<String, dynamic> toJson() => _$ScanItemToJson(this);

  /// Создание объекта из Map (например, для работы с локальной БД)
  factory ScanItem.fromMap(Map<String, dynamic> map) {
    return ScanItem(
      text: map['item_name'] as String,
      count: map['quantity'] as int,
      unitId: map['unit_id'] as int,
    );
  }

  /// Преобразование объекта в Map
  Map<String, dynamic> toMap() {
    return {
      'item_name': text,
      'quantity': count,
      'unit_id': unitId,
    };
  }
}
