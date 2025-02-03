import 'package:phytosvit/database/sq_light/doc_type_helper.dart';
import 'package:phytosvit/database/sq_light/documents_helper.dart';
import 'package:phytosvit/database/sq_light/subdivisions_helper.dart';
import 'package:phytosvit/database/sq_light/units_helper.dart';
import 'package:phytosvit/database/sq_light/users_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String DATABASE_NAME = 'app_database.db';
  static const int DATABASE_VERSION = 1;

  static Database? _database;

  // Получение экземпляра базы данных
  Future<Database> get database async {
    if (_database != null) return _database!;
    // await recreateDatabase();
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
    );
  }

  // Метод для создания таблиц
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(DBUsersHelperLite.CREATE_TABLE_USERS);
    await db.execute(DBSubdivisionsHelperLite.CREATE_TABLE_SUBDIVISION);
    await db.execute(DBUnitsHelperLite.CREATE_TABLE_UNITS);
    await db.execute(DBDocTypeHelperLite.CREATE_TABLE_DOC_TYPES);
    await db.execute(DBDocumentHelperLite.CREATE_TABLE_ITEMS);
    await db.execute(DBDocumentHelperLite.CREATE_TABLE_DOCUMENTS);
  }

  // Метод для обновления базы данных
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS subdivisions');
    await db.execute('DROP TABLE IF EXISTS units');
    await db.execute('DROP TABLE IF EXISTS users');
    await db.execute('DROP TABLE IF EXISTS items');
    await db.execute('DROP TABLE IF EXISTS doc_types');
    await db.execute('DROP TABLE IF EXISTS documets');
    await _onCreate(db, newVersion);
  }

  // Метод для пересоздания базы данных
  Future<void> recreateDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DATABASE_NAME);

    // Удаление существующей базы данных
    await deleteDatabase(path);

    // Создание новой базы данных с вызовом _onUpgrade
    final db = await openDatabase(
      path,
      version: DATABASE_VERSION,
      onCreate: (db, version) => _onCreate(db, version),
      onUpgrade: (db, oldVersion, newVersion) =>
          _onUpgrade(db, oldVersion, newVersion),
    );

    // Вызываем явно _onUpgrade для пересоздания структуры
    await _onUpgrade(db, 0, DATABASE_VERSION);

    // Закрываем базу данных после выполнения
    await db.close();
  }
}
