class ScanItem {
  String text;
  int count;
  int unitId;

  ScanItem({
    required this.text,
    required this.count,
    required this.unitId,
  });

  // Создание объекта из Map
  factory ScanItem.fromMap(Map<String, dynamic> map) {
    return ScanItem(
      text: map['item_name'] as String,
      count: map['quantity'] as int,
      unitId: map['unit_id'] as int,
    );
  }

  // Преобразование объекта в Map
  Map<String, dynamic> toMap() {
    return {
      'item_name': text,
      'quantity': count,
      'unit_id': unitId,
    };
  }
}
