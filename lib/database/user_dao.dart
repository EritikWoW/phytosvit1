import 'package:flutter/material.dart';
import 'package:phytosvit/database/sq_light/database_helper.dart';
import 'package:phytosvit/models/user.dart';
import 'package:sqflite/sqflite.dart';

class UserDao {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Вставка нескольких пользователей в базу данных
  Future<void> insertUsers(List<User> users) async {
    final db = await _databaseHelper.database;
    Batch batch = db.batch();

    for (var user in users) {
      batch.insert(
        'users',
        user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit();
  }

  // Вставка одного пользователя в базу данных
  Future<void> insertUser(User user) async {
    final db = await _databaseHelper.database;
    await db.insert(
      'users',
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Получение всех пользователей из базы данных
  Future<List<User>> getUsers() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    return maps.map((map) => User.fromJson(map)).toList();
  }

  // Обновление статуса синхронизации пользователя
  Future<void> updateUserSyncStatus(User user) async {
    final db = await _databaseHelper.database;
    await db.update(
      'users',
      {'isSynced': user.isSynced ? 1 : 0},
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Получение пользователя по email
  Future<User?> getUserByEmail(String email) async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> result = await db.query(
        'users',
        where: 'userEmail = ?',
        whereArgs: [email],
      );

      if (result.isNotEmpty) {
        return User.fromJson(result.first);
      }
    } catch (e) {
      debugPrint('Error fetching user by email: $e');
    }
    return null;
  }

  // Обновление пользователя в базе данных
  Future<void> updateUser(User user) async {
    final db = await _databaseHelper.database;

    await db.update(
      'users',
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
    debugPrint('Пользователь с ID ${user.id} обновлен');
  }
}
