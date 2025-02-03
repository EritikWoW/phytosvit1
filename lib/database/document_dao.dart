import 'package:flutter/cupertino.dart';
import 'package:phytosvit/database/sq_light/document_helper.dart';

import '../models/document.dart';
import '../models/scan_item.dart';

class DocumentDao {
  final DBDocumentHelperLite _dbHelper = DBDocumentHelperLite();

  // Вставка нового документа
  Future<int> insertDocumentWithItems(Document document) async {
    final db = await _dbHelper.database;
    try {
      return await db.transaction((txn) async {
        // Вставляем документ и получаем его ID
        final documentId = await txn.insert(
          DBDocumentHelperLite.TABLE_DOCUMENTS,
          document.toMap(),
        );

        // Вставляем связанные товары
        for (final item in document.items) {
          final itemMap = item.toMap();
          itemMap[DBDocumentHelperLite.COLUMN_DOCUMENT_ID_FK] = documentId;

          try {
            await txn.insert(DBDocumentHelperLite.TABLE_ITEMS, itemMap);
          } catch (e) {
            print('Error inserting item: $e');
            rethrow;
          }
        }

        return documentId;
      });
    } catch (e) {
      debugPrint('Error in transaction: $e');
      print('Error in transaction: $e');
      rethrow; // Пробрасываем исключение, чтобы можно было обработать его в вызывающем методе
    }
  }

  // Получение всех документов
  Future<List<Document>> getAllDocuments() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query(DBDocumentHelperLite.TABLE_DOCUMENTS);
    return maps.map((map) => Document.fromMap(map)).toList();
  }

  // Получение товаров по ID документа
  Future<List<ScanItem>> getItemsByDocumentId(int documentId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DBDocumentHelperLite.TABLE_ITEMS,
      where: '${DBDocumentHelperLite.COLUMN_DOCUMENT_ID_FK} = ?',
      whereArgs: [documentId],
    );

    // Преобразование списка карт в список объектов ScanItem
    return maps.map((map) => ScanItem.fromMap(map)).toList();
  }

  // Удаление документа по ID
  Future<int> deleteDocument(int documentId) async {
    final db = await _dbHelper.database;
    return await db.transaction((txn) async {
      await txn.delete(
        DBDocumentHelperLite.TABLE_ITEMS,
        where: '${DBDocumentHelperLite.COLUMN_DOCUMENT_ID_FK} = ?',
        whereArgs: [documentId],
      );
      return await txn.delete(
        DBDocumentHelperLite.TABLE_DOCUMENTS,
        where: '${DBDocumentHelperLite.COLUMN_DOCUMENT_ID} = ?',
        whereArgs: [documentId],
      );
    });
  }

  // Удаление товара по ID
  Future<int> deleteItem(int itemId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DBDocumentHelperLite.TABLE_ITEMS,
      where: '${DBDocumentHelperLite.COLUMN_ITEM_ID} = ?',
      whereArgs: [itemId],
    );
  }

  // Обновление документа
  Future<int> updateDocument(
      int documentId, Map<String, dynamic> document) async {
    final db = await _dbHelper.database;
    return await db.update(
      DBDocumentHelperLite.TABLE_DOCUMENTS,
      document,
      where: '${DBDocumentHelperLite.COLUMN_DOCUMENT_ID} = ?',
      whereArgs: [documentId],
    );
  }

  // Обновление товара
  Future<int> updateItem(int itemId, Map<String, dynamic> item) async {
    final db = await _dbHelper.database;
    return await db.update(
      DBDocumentHelperLite.TABLE_ITEMS,
      item,
      where: '${DBDocumentHelperLite.COLUMN_ITEM_ID} = ?',
      whereArgs: [itemId],
    );
  }

  // Получение всех столбцов таблицы
  Future<List<String>> getColumns(String tableName) async {
    final db = await _dbHelper.database;
    try {
      final List<Map<String, dynamic>> result =
          await db.rawQuery('PRAGMA table_info($tableName)');
      return result.map((row) => row['name'] as String).toList();
    } catch (e) {
      debugPrint('Error fetching columns for table $tableName: $e');
      rethrow;
    }
  }
}
