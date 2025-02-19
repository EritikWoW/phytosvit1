import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:phytosvit/models/document.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../database/document_dao.dart';
import '../models/scan_item.dart';

class DocumentSyncService {
  final DocumentDao documentDao;

  DocumentSyncService(this.documentDao);

  // Проверка подключения к интернету
  Future<bool> _isConnectedToInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Проверка доступности сервера (например, по эндпоинту /ping)
  Future<bool> isServerAvailable() async {
    final url = await _getApiUrl('/ping');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Ошибка подключения к серверу: $e');
      return false;
    }
  }

  // Получение URL API (например, http://your-api-address/endpoint)
  Future<Uri> _getApiUrl(String endpoint) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiAddress = prefs.getString('api_address') ?? '';
    return Uri.parse('http://$apiAddress$endpoint');
  }

  // Получение заголовков для HTTP-запросов
  Future<Map<String, String>> _getHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiToken = prefs.getString('api_token') ?? '';
    return {
      'Authorization': 'Bearer $apiToken',
      'Content-Type': 'application/json',
    };
  }

  // Основной метод синхронизации документов
  Future<void> syncDocuments(Document doc) async {
    if (await _isConnectedToInternet()) {
      if (await isServerAvailable()) {
        debugPrint('Сервер доступен. Синхронизация документов...');
        await _saveDocumentsFromServer(doc);
      } else {
        debugPrint('Сервер недоступен. Работаем с локальной базой.');
      }
    } else {
      debugPrint('Нет подключения к интернету. Работаем с локальной базой.');
    }
  }

  Future<void> _saveDocumentsFromServer(Document doc) async {
    // Получаем URL для /documents/create
    final url = await _getApiUrl('/documents/create');

    // Получаем заголовки (авторизация + content-type)
    final headers = await _getHeaders();

    // Формируем тело запроса в формате JSON
    final requestBody = {
      'date': doc.date,
      'subdivisionId': doc.subdivisionId,
      'typeId': doc.documentTypeId,
      'items': doc.items
    };

    try {
      // Отправляем POST-запрос
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        // Успех: сервер вернул код 201 "Created"
        final data = jsonDecode(response.body);
        final documentId = data['documentId'];
        debugPrint('Документ успешно создан на сервере. ID = $documentId');

        // Если нужно, можно здесь обновить локальную БД,
        // чтобы сохранить связь с серверным ID и пометить документ как "синхронизированный".
      } else {
        // Сервер вернул ошибку (4xx/5xx)
        debugPrint(
            'Ошибка при создании документа. Код ответа: ${response.statusCode}');
        debugPrint('Тело ответа: ${response.body}');
      }
    } catch (e) {
      // Ошибка на уровне сети / исключения
      debugPrint('Ошибка при отправке запроса: $e');
    }
  }
}
