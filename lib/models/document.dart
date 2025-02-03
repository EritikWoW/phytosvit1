import 'package:phytosvit/models/scan_item.dart';

class Document {
  int id;
  String date;
  int subdivisionId;
  int documentTypeId;
  List<ScanItem> items;

  Document({
    required this.id,
    required this.date,
    required this.subdivisionId,
    required this.documentTypeId,
    required this.items,
  });

  // Создание объекта из Map
  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      id: map['id'] as int,
      date: map['date'] as String,
      subdivisionId: map['subdivision_id'] as int,
      documentTypeId: map['type_id'] as int,
      items: map['items'] as List<ScanItem>,
      // items: (map['items'] as List<dynamic>)
      //     .map((item) => ScanItem.fromMap(item as Map<String, dynamic>))
      //     .toList(),
    );
  }

  // Преобразование объекта в Map
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'subdivision_id': subdivisionId,
      'type_id': documentTypeId,
      //'items': items,
    };
  }
}
