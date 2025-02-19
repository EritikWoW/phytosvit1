import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:phytosvit/database/document_dao.dart';

import 'package:phytosvit/database/sq_light/document_helper.dart';
import 'package:phytosvit/database/sq_light/subdivisions_helper.dart';
import 'package:phytosvit/models/document.dart';
import 'package:phytosvit/models/scan_item.dart';
import 'package:phytosvit/models/subdivision.dart';
import 'package:phytosvit/services/document_sync_service.dart';

// -------------------------------
// Вспомогательный класс для данных,
// возвращаемых из _fetchDocuments().
// Храним и документы, и подразделения.
// -------------------------------
class DocumentsData {
  final List<Document> documents;
  final List<Subdivision> subdivs;

  DocumentsData({
    required this.documents,
    required this.subdivs,
  });
}

// Переименовали в StatefulWidget
class DocumentsWidget extends StatefulWidget {
  const DocumentsWidget({super.key});

  @override
  DocumentsWidgetState createState() => DocumentsWidgetState();
}

// Сделали класс состояния публичным (чтобы можно было обращаться к нему через GlobalKey)
class DocumentsWidgetState extends State<DocumentsWidget> {
  final DBDocumentHelperLite _dbHelper = DBDocumentHelperLite();
  final DBSubdivisionsHelperLite _subHelper = DBSubdivisionsHelperLite();
  late final DocumentDao documentDao;
  late final DocumentSyncService syncService;

  late Future<DocumentsData> _futureData; // Хранит Future<DocumentsData>

  @override
  void initState() {
    super.initState();
    documentDao = DocumentDao();
    syncService = DocumentSyncService(documentDao);
    _loadDocuments();
  }

  // Этот метод можно вызывать извне, если нужно обновить список
  Future<void> refreshDocuments() async {
    _loadDocuments();
    setState(() {});
  }

  // Вспомогательный метод, вызываемый при initState и refresh
  void _loadDocuments() {
    _futureData = _fetchDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: FutureBuilder<DocumentsData>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Ошибка загрузки документов: ${snapshot.error}'),
            );
          }

          // Извлекаем готовый объект с двумя списками
          final data = snapshot.data;
          if (data == null) {
            return const Center(child: Text('Нет данных'));
          }

          final documents = data.documents;
          final subdivs = data.subdivs;

          if (documents.isEmpty) {
            return _buildNoDocuments();
          } else {
            return _buildDocumentsList(documents, subdivs, context);
          }
        },
      ),
    );
  }

  // ---------------------------
  // Запрос документов + подразделений
  // ---------------------------
  Future<DocumentsData> _fetchDocuments() async {
    // 1. Параллельно загружаем список документов и подразделений
    final results = await Future.wait([
      _dbHelper.getDocuments(),
      _subHelper.getSubdivision(),
    ]);

    // results[0] -> documentsMap
    // results[1] -> subdivsMap
    final documentsMap = results[0];
    final subdivsMap = results[1];

    // 2. Преобразуем подразделения (локальная переменная)
    final subdivs = subdivsMap.map((map) => Subdivision.fromMap(map)).toList();

    // 3. Для каждого документа параллельно загружаем items
    final futures = documentsMap.map((doc) async {
      final itemsMap = await _dbHelper.getItemsByDocumentId(doc['id']);
      final items = itemsMap.map((item) => ScanItem.fromMap(item)).toList();

      final docCopy = Map<String, dynamic>.from(doc);
      docCopy['items'] = items;

      // Создаём Document
      return Document.fromMap(docCopy);
    }).toList();

    // 4. Ожидаем завершения всех Future
    final documents = await Future.wait(futures);

    // 5. Возвращаем оба списка в одном объекте
    return DocumentsData(
      documents: documents,
      subdivs: subdivs,
    );
  }

  // ---------------------------
  // Сообщение "документов нет"
  // ---------------------------
  Widget _buildNoDocuments() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/svg/empty_docs.svg'),
        const SizedBox(height: 16),
        const Text(
          'У вас немає документів',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Синхронізація документів на смартфонах, планшетах і комп\'ютерах',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }

  // ---------------------------
  // Построение списка документов
  // ---------------------------
  Widget _buildDocumentsList(
    List<Document> documents,
    List<Subdivision> subdivs,
    BuildContext context,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final document = documents[index];

        // Форматируем дату
        final formattedDate = _formatDate(document.date);

        // Определяем название подразделения по subdivisionId
        final subdivisionName = subdivs
            .firstWhere(
              (subdivision) => subdivision.id == document.subdivisionId,
              orElse: () => Subdivision(
                subdivisionName: 'Неизвестное подразделение',
              ),
            )
            .subdivisionName;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Dismissible(
            key: Key(document.id.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              await _deleteDocument(document.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Документ удален')),
              );
            },
            background: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20.0),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 16,
                ),
                title: Text(
                  formattedDate.isEmpty ? 'Без даты' : formattedDate,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                subtitle: Text(
                  subdivisionName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (String value) async {
                    switch (value) {
                      case 'sync':
                        syncService.syncDocuments(document);
                        break;
                      case 'edit':
                        // Открыть экран редактирования или другую операцию
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Нажата кнопка "Редактировать" для документа ${document.id}',
                            ),
                          ),
                        );
                        break;
                      case 'delete':
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Подтвердите удаление'),
                            content: Text(
                              'Удалить документ с ID = ${document.id}?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Отмена'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Удалить'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await _deleteDocument(document.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Документ ${document.id} удален'),
                            ),
                          );
                        }
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'sync',
                        child: Text('Синхронізувати'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: Text('Редактировать'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Удалить'),
                      ),
                    ];
                  },
                ),
                onTap: () {
                  debugPrint('Открыть документ: ${document.subdivisionId}');
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------------------------
  // Удаление документа
  // ---------------------------
  Future<void> _deleteDocument(int documentId) async {
    try {
      await _dbHelper.deleteDocument(documentId);
    } catch (e) {
      debugPrint("Ошибка при удалении документа: $e");
    }
  }

  // ---------------------------
  // Форматирование даты
  // ---------------------------
  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd.MM.yyyy HH:mm').format(date);
    } catch (e) {
      return 'Неверный формат даты';
    }
  }
}
