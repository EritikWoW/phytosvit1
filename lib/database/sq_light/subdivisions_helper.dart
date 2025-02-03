import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBSubdivisionsHelperLite {
  static const String DATABASE_NAME = 'app_database.db';
  static const int DATABASE_VERSION = 2;

  // Таблица подразделений
  static const String TABLE_SUBDIVISION = 'subdivisions';
  static const String COLUMN_SUBDIVISION_ID = 'id';
  static const String COLUMN_SUBDIVISION_NAME = 'subdivision_name';

  // Создание таблицы подразделений
  static const String CREATE_TABLE_SUBDIVISION = '''
    CREATE TABLE IF NOT EXISTS $TABLE_SUBDIVISION (
      $COLUMN_SUBDIVISION_ID INTEGER PRIMARY KEY AUTOINCREMENT,
      $COLUMN_SUBDIVISION_NAME TEXT NOT NULL
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
    await db.execute(CREATE_TABLE_SUBDIVISION);
  }

  // Обновление базы данных
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS $TABLE_SUBDIVISION');
    await _onCreate(db, newVersion);
  }

  // Получение всех
  Future<List<Map<String, dynamic>>> getSubdivision() async {
    final db = await database;
    return await db.query(TABLE_SUBDIVISION);
  }

  // Добавление новой
  Future<int> insertSubdivision(Map<String, dynamic> subdivision) async {
    final db = await database;
    return await db.insert(TABLE_SUBDIVISION, subdivision);
  }

  // Обновление
  Future<int> updateSubdivision(int id, Map<String, dynamic> unit) async {
    final db = await database;
    return await db.update(
      TABLE_SUBDIVISION,
      unit,
      where: '$COLUMN_SUBDIVISION_ID = ?',
      whereArgs: [id],
    );
  }

  // Удаление
  Future<int> deleteSubdivision(int id) async {
    final db = await database;
    return await db.delete(
      TABLE_SUBDIVISION,
      where: '$COLUMN_SUBDIVISION_ID = ?',
      whereArgs: [id],
    );
  }
}
