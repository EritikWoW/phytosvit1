import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DBDocumentHelperLite {
  static const String DATABASE_NAME = 'app_database.db';
  static const int DATABASE_VERSION = 1;

  // Таблица документов
  static const String TABLE_DOCUMENTS = 'documents';
  static const String COLUMN_DOCUMENT_ID = 'id';
  static const String COLUMN_DATE = 'date';
  static const String COLUMN_SUBDIVISION_ID_FK = 'subdivision_id';
  static const String COLUMN_DOCUMENT_TYPE_ID = 'type_id';

  // Таблица товаров
  static const String TABLE_ITEMS = 'items';
  static const String COLUMN_ITEM_ID = 'id';
  static const String COLUMN_ITEM_NAME = 'item_name';
  static const String COLUMN_QUANTITY = 'quantity';
  static const String COLUMN_UNIT_ID_FK = 'unit_id';
  static const String COLUMN_DOCUMENT_ID_FK = 'document_id';

  static Database? _database;

  // Получение экземпляра базы данных
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Инициализация базы данных
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DATABASE_NAME);

    return await openDatabase(
      path,
      version: DATABASE_VERSION,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onOpen: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  // Метод для создания таблиц
  Future<void> _onCreate(Database db, int version) async {
    // Создание таблицы документов
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_DOCUMENTS (
        $COLUMN_DOCUMENT_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $COLUMN_DATE TEXT,
        $COLUMN_SUBDIVISION_ID_FK INTEGER,
        $COLUMN_DOCUMENT_TYPE_ID INTEGER,
        FOREIGN KEY($COLUMN_SUBDIVISION_ID_FK) REFERENCES subdivisions(id),
        FOREIGN KEY($COLUMN_DOCUMENT_TYPE_ID) REFERENCES doc_types(id) 
      );
    ''');

    // Создание таблицы товаров
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $TABLE_ITEMS (
        $COLUMN_ITEM_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $COLUMN_ITEM_NAME TEXT,
        $COLUMN_QUANTITY INTEGER,
        $COLUMN_UNIT_ID_FK INTEGER,
        $COLUMN_DOCUMENT_ID_FK INTEGER,
        FOREIGN KEY($COLUMN_DOCUMENT_ID_FK) REFERENCES $TABLE_DOCUMENTS($COLUMN_DOCUMENT_ID),
        FOREIGN KEY($COLUMN_UNIT_ID_FK) REFERENCES units(id)
      );
    ''');
  }

  // Метод для обновления базы данных
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS $TABLE_ITEMS');
    await db.execute('DROP TABLE IF EXISTS $TABLE_DOCUMENTS');
    _onCreate(db, newVersion);
  }

  // Вставка документа
  Future<int> insertDocument(Map<String, dynamic> document) async {
    final db = await database;
    return await db.insert(TABLE_DOCUMENTS, document,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Вставка товара
  Future<int> insertItem(Map<String, dynamic> item) async {
    final db = await database;
    return await db.insert(TABLE_ITEMS, item,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Получение всех документов
  Future<List<Map<String, dynamic>>> getDocuments() async {
    final db = await database;
    return await db.query(TABLE_DOCUMENTS);
  }

  // Получение всех товаров по документу
  Future<List<Map<String, dynamic>>> getItemsByDocumentId(
      int documentId) async {
    final db = await database;
    return await db.query(TABLE_ITEMS,
        where: '$COLUMN_DOCUMENT_ID_FK = ?', whereArgs: [documentId]);
  }

  Future<void> deleteDocument(int documentId) async {
    try {
      final db = await database;

      await db.delete(
        'items',
        where: 'document_id = ?',
        whereArgs: [documentId],
      );
      print('Все элементы, связанные с документом $documentId, удалены');

      await db.delete(
        'documents',
        where: 'id = ?',
        whereArgs: [documentId],
      );
      print('Документ с id $documentId успешно удален');
    } catch (e) {
      print('Ошибка при удалении документа и его элементов: $e');
      throw Exception('Ошибка при удалении документа и его элементов');
    }
  }
}
