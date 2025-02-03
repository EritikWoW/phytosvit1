import 'package:phytosvit/database/sq_light/database_helper.dart';
import 'package:phytosvit/database/sq_light/units_helper.dart';
import 'package:phytosvit/models/unit.dart';

class UnitDao {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Получение всех единиц измерения
  Future<List<Unit>> getAllUnits() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query(DBUnitsHelperLite.TABLE_UNITS);
    return maps.map((map) => Unit.fromMap(map)).toList();
  }

  // Получение единицы измерения по ID
  Future<Unit?> getUnitById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DBUnitsHelperLite.TABLE_UNITS,
      where: '${DBUnitsHelperLite.COLUMN_UNIT_ID} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Unit.fromMap(maps.first);
    }
    return null;
  }

  // Добавление новой единицы измерения
  Future<int> insertUnit(Unit unit) async {
    final db = await _databaseHelper.database;
    return await db.insert(DBUnitsHelperLite.TABLE_UNITS, unit.toMap());
  }

  // Обновление существующей единицы измерения
  Future<int> updateUnit(Unit unit) async {
    final db = await _databaseHelper.database;
    return await db.update(
      DBUnitsHelperLite.TABLE_UNITS,
      unit.toMap(),
      where: '${DBUnitsHelperLite.COLUMN_UNIT_ID} = ?',
      whereArgs: [unit.id],
    );
  }

  // Удаление единицы измерения
  Future<int> deleteUnit(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      DBUnitsHelperLite.TABLE_UNITS,
      where: '${DBUnitsHelperLite.COLUMN_UNIT_ID} = ?',
      whereArgs: [id],
    );
  }
}
