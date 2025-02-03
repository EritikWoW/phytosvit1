import 'package:phytosvit/database/sq_light/database_helper.dart';
import 'package:phytosvit/models/subdivision.dart';

class SubdivisionDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Subdivision>> getAllSubdivisions() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('subdivisions');
    return maps.map((map) => Subdivision.fromMap(map)).toList();
  }

  Future<Subdivision?> getSubdivisionById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'subdivisions',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Subdivision.fromMap(maps.first);
    }
    return null;
  }

  Future<int> insertSubdivision(Subdivision subdivision) async {
    final db = await _dbHelper.database;
    return await db.insert('subdivisions', subdivision.toMap());
  }

  Future<int> updateSubdivision(Subdivision subdivision) async {
    final db = await _dbHelper.database;
    return await db.update(
      'subdivisions',
      subdivision.toMap(),
      where: 'id = ?',
      whereArgs: [subdivision.id],
    );
  }

  Future<int> deleteSubdivision(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'subdivisions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
