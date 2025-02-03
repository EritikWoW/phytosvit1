import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBDocTypeHelperLite {
  static const String DATABASE_NAME = 'app_database.db';
  static const int DATABASE_VERSION = 1;

  // Таблица типов документов
  static const String TABLE_DOC_TYPES = 'doc_types';
  static const String COLUMN_DOC_TYPE_ID = 'id';
  static const String COLUMN_DOC_TYPE_NAME = 'type_name';

  // Создание таблицы типов документов
  static const String CREATE_TABLE_DOC_TYPES = '''
    CREATE TABLE IF NOT EXISTS $TABLE_DOC_TYPES (
      $COLUMN_DOC_TYPE_ID INTEGER PRIMARY KEY AUTOINCREMENT,
      $COLUMN_DOC_TYPE_NAME TEXT NOT NULL
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
    await db.execute(CREATE_TABLE_DOC_TYPES);
  }

  // Обновление базы данных
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS $TABLE_DOC_TYPES');
    await _onCreate(db, newVersion);
  }

  // Получение всех типов документов
  Future<List<Map<String, dynamic>>> getDocTypes() async {
    final db = await database;
    return await db.query(TABLE_DOC_TYPES);
  }

  // Добавление нового типа документа
  Future<int> insertDocType(Map<String, dynamic> docType) async {
    final db = await database;
    return await db.insert(TABLE_DOC_TYPES, docType);
  }

  // Обновление типа документа
  Future<int> updateDocType(int id, Map<String, dynamic> docType) async {
    final db = await database;
    return await db.update(
      TABLE_DOC_TYPES,
      docType,
      where: '$COLUMN_DOC_TYPE_ID = ?',
      whereArgs: [id],
    );
  }

  // Удаление типа документа
  Future<int> deleteDocType(int id) async {
    final db = await database;
    return await db.delete(
      TABLE_DOC_TYPES,
      where: '$COLUMN_DOC_TYPE_ID = ?',
      whereArgs: [id],
    );
  }
}
