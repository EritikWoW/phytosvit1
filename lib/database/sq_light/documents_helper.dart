import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

  // Создание таблицы документов
  static const String CREATE_TABLE_DOCUMENTS = '''
      CREATE TABLE IF NOT EXISTS $TABLE_DOCUMENTS (
        $COLUMN_DOCUMENT_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $COLUMN_DATE TEXT,
        $COLUMN_SUBDIVISION_ID_FK INTEGER,
        $COLUMN_DOCUMENT_TYPE_ID INTEGER,
        FOREIGN KEY($COLUMN_SUBDIVISION_ID_FK) REFERENCES subdivisions(id),
        FOREIGN KEY($COLUMN_DOCUMENT_TYPE_ID) REFERENCES doc_types(id) 
      );
    ''';

  // Создание таблицы товаров
  static const String CREATE_TABLE_ITEMS = '''
    CREATE TABLE IF NOT EXISTS $TABLE_ITEMS (
      $COLUMN_ITEM_ID INTEGER PRIMARY KEY AUTOINCREMENT,
      $COLUMN_ITEM_NAME TEXT,
      $COLUMN_QUANTITY INTEGER,
      $COLUMN_UNIT_ID_FK INTEGER,
      $COLUMN_DOCUMENT_ID_FK INTEGER,
      FOREIGN KEY($COLUMN_DOCUMENT_ID_FK) REFERENCES $TABLE_DOCUMENTS($COLUMN_DOCUMENT_ID),
      FOREIGN KEY($COLUMN_UNIT_ID_FK) REFERENCES units(id)
    );
  ''';

  // Получение базы данных
  Future<Database> _getDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DATABASE_NAME);
    return openDatabase(path,
        version: DATABASE_VERSION, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  // Создание таблиц в базе данных
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(CREATE_TABLE_DOCUMENTS);
    await db.execute(CREATE_TABLE_ITEMS);
  }

  // Обновление базы данных
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS $TABLE_ITEMS');
    await db.execute('DROP TABLE IF EXISTS $TABLE_DOCUMENTS');
    await _onCreate(db, newVersion);
  }

  // Получение данных из таблицы документов
  Future<List<Map<String, dynamic>>> getDocuments() async {
    final db = await _getDatabase();
    return await db.query(TABLE_DOCUMENTS);
  }

  // Добавление нового документа
  Future<int> insertDocument(Map<String, dynamic> document) async {
    final db = await _getDatabase();
    return await db.insert(TABLE_DOCUMENTS, document);
  }

  // Получение всех товаров
  Future<List<Map<String, dynamic>>> getItems() async {
    final db = await _getDatabase();
    return await db.query(TABLE_ITEMS);
  }

  // Добавление нового товара
  Future<int> insertItem(Map<String, dynamic> item) async {
    final db = await _getDatabase();
    return await db.insert(TABLE_ITEMS, item);
  }
}
