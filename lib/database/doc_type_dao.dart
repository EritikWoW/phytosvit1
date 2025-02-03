import 'package:flutter/material.dart';
import 'package:phytosvit/database/sq_light/database_helper.dart';
import 'package:phytosvit/models/doc_type.dart';
import 'package:sqflite/sqflite.dart';

class DocTypeDao {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Вставка нескольких типов документов в базу данных
  Future<void> insertDocTypes(List<DocType> docTypes) async {
    final db = await _databaseHelper.database;
    Batch batch = db.batch();

    for (var docType in docTypes) {
      batch.insert(
        'doc_types',
        docType.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit();
  }

  // Вставка одного типа документа в базу данных
  Future<void> insertDocType(DocType docType) async {
    final db = await _databaseHelper.database;
    await db.insert(
      'doc_types',
      docType.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Получение всех типов документов из базы данных
  Future<List<DocType>> getDocTypes() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('doc_types');

    return maps.map((map) => DocType.fromJson(map)).toList();
  }

  // Обновление типа документа в базе данных
  Future<void> updateDocType(DocType docType) async {
    final db = await _databaseHelper.database;

    await db.update(
      'doc_types',
      docType.toJson(),
      where: 'id = ?',
      whereArgs: [docType.id],
    );
    debugPrint('Тип документа с ID ${docType.id} обновлен');
  }

  // Получение типа документа по ID
  Future<DocType?> getDocTypeById(int id) async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> result = await db.query(
        'doc_types',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result.isNotEmpty) {
        return DocType.fromJson(result.first);
      }
    } catch (e) {
      debugPrint('Error fetching doc type by ID: $e');
    }
    return null;
  }

  // Удаление типа документа из базы данных
  Future<void> deleteDocType(int id) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'doc_types',
      where: 'id = ?',
      whereArgs: [id],
    );
    debugPrint('Тип документа с ID $id удален');
  }
}
