import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBUnitsHelperLite {
  static const String DATABASE_NAME = 'app_database.db';
  static const int DATABASE_VERSION = 1;

  // Таблица единиц измерения
  static const String TABLE_UNITS = 'units';
  static const String COLUMN_UNIT_ID = 'id';
  static const String COLUMN_UNIT_NAME = 'unit_name';

  // Создание таблицы единиц измерения
  static const String CREATE_TABLE_UNITS = '''
    CREATE TABLE IF NOT EXISTS $TABLE_UNITS (
      $COLUMN_UNIT_ID INTEGER PRIMARY KEY AUTOINCREMENT,
      $COLUMN_UNIT_NAME TEXT NOT NULL
    );
  ''';

  Database? _database;

  // Геттер для получения экземпляра базы данных (синглтон)
  Future<Database> get database async {
    if (_database != null) return _database!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DATABASE_NAME);

    _database = await openDatabase(
      path,
      version: DATABASE_VERSION,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return _database!;
  }

  // Создание таблицы
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(CREATE_TABLE_UNITS);
  }

  // Обновление базы данных
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS $TABLE_UNITS');
    await _onCreate(db, newVersion);
  }

  // Получение всех единиц измерения
  Future<List<Map<String, dynamic>>> getUnits() async {
    final db =
        await database; // Используем геттер _db для получения базы данных
    return await db.query(TABLE_UNITS);
  }

  // Добавление новой единицы измерения
  Future<int> insertUnit(Map<String, dynamic> unit) async {
    final db =
        await database; // Используем геттер _db для получения базы данных
    return await db.insert(TABLE_UNITS, unit);
  }

  // Обновление единицы измерения
  Future<int> updateUnit(int id, Map<String, dynamic> unit) async {
    final db =
        await database; // Используем геттер _db для получения базы данных
    return await db.update(
      TABLE_UNITS,
      unit,
      where: '$COLUMN_UNIT_ID = ?',
      whereArgs: [id],
    );
  }

  // Удаление единицы измерения
  Future<int> deleteUnit(int id) async {
    final db =
        await database; // Используем геттер _db для получения базы данных
    return await db.delete(
      TABLE_UNITS,
      where: '$COLUMN_UNIT_ID = ?',
      whereArgs: [id],
    );
  }
}
