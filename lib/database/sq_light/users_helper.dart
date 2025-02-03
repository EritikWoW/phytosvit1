import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBUsersHelperLite {
  static const String DATABASE_NAME = 'app_database.db';
  static const int DATABASE_VERSION = 1;

  // Таблица пользователей
  static const String TABLE_USERS = 'users';
  static const String COLUMN_USER_ID = 'id';
  static const String COLUMN_USER_NAME = 'userName';
  static const String COLUMN_USER_SURNAME = 'userSurname';
  static const String COLUMN_USER_BIRTHDAY = 'userBirthDay';
  static const String COLUMN_USER_EMAIL = 'userEmail';
  static const String COLUMN_USER_PASSWORD = 'userPassword';
  static const String COLUMN_USER_ROLE = 'userRole';
  static const String COLUMN_USER_PHONE = 'userPhone';
  static const String COLUMN_USER_PHOTO = 'userPhoto';

  // Создание таблицы пользователей
  static const String CREATE_TABLE_USERS = '''
    CREATE TABLE IF NOT EXISTS $TABLE_USERS (
      $COLUMN_USER_ID INTEGER PRIMARY KEY AUTOINCREMENT,
      $COLUMN_USER_NAME TEXT NOT NULL,
      $COLUMN_USER_SURNAME TEXT NOT NULL,
      $COLUMN_USER_BIRTHDAY TEXT NOT NULL,
      $COLUMN_USER_EMAIL TEXT NOT NULL,
      $COLUMN_USER_PASSWORD TEXT NOT NULL,
      $COLUMN_USER_ROLE INTEGER NOT NULL,
      $COLUMN_USER_PHONE TEXT,
      $COLUMN_USER_PHOTO TEXT
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

  // Создание таблицы при инициализации базы данных
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(CREATE_TABLE_USERS);
  }

  // Обновление структуры базы данных
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS $TABLE_USERS');
    await _onCreate(db, newVersion);
  }

  // Получение всех пользователей
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query(TABLE_USERS);
  }

  // Получение пользователя по ID
  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await database;
    final result = await db.query(
      TABLE_USERS,
      where: '$COLUMN_USER_ID = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Добавление нового пользователя
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert(TABLE_USERS, user);
  }

  // Обновление данных пользователя
  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    final db = await database;
    return await db.update(
      TABLE_USERS,
      user,
      where: '$COLUMN_USER_ID = ?',
      whereArgs: [id],
    );
  }

  // Удаление пользователя
  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      TABLE_USERS,
      where: '$COLUMN_USER_ID = ?',
      whereArgs: [id],
    );
  }
}
