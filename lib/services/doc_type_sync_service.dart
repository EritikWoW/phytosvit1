import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:phytosvit/database/doc_type_dao.dart';
import 'package:phytosvit/models/doc_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class DocTypeSyncService {
  final DocTypeDao docTypeDao;

  DocTypeSyncService(this.docTypeDao);

  // Проверка подключения к интернету
  Future<bool> _isConnectedToInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Проверка доступности сервера
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

  // Получение URL API
  Future<Uri> _getApiUrl(String endpoint) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiAddress = prefs.getString('api_address') ?? '';
    return Uri.parse('http://$apiAddress$endpoint');
  }

  // Получение заголовков для запросов
  Future<Map<String, String>> _getHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiToken = prefs.getString('api_token') ?? '';
    return {
      'Authorization': 'Bearer $apiToken',
      'Content-Type': 'application/json',
    };
  }

  // Основной метод синхронизации
  Future<void> syncDocTypes() async {
    if (await _isConnectedToInternet()) {
      if (await isServerAvailable()) {
        debugPrint('Сервер доступен. Синхронизация типов документов...');
        await _fetchAndSaveDocTypesFromServer();
      } else {
        debugPrint('Сервер недоступен. Работаем с локальной базой.');
      }
    } else {
      debugPrint('Нет подключения к интернету. Работаем с локальной базой.');
    }
  }

  // Загрузка данных с сервера в локальную базу данных
  Future<void> _fetchAndSaveDocTypesFromServer() async {
    final url = await _getApiUrl('/types/getall');
    try {
      final response = await http.get(url, headers: await _getHeaders());

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['data'];
        List<DocType> serverDocTypes =
            data.map((json) => DocType.fromJson(json)).toList();

        for (var docType in serverDocTypes) {
          final existingDocType = await docTypeDao.getDocTypeById(docType.id!);

          if (existingDocType != null) {
            if (!_isDocTypeDataEqual(existingDocType, docType)) {
              await docTypeDao.updateDocType(docType);
              debugPrint('Тип документа "${docType.typeName}" обновлен.');
            } else {
              debugPrint(
                  'Данные типа документа "${docType.typeName}" не изменились.');
            }
          } else {
            await docTypeDao.insertDocType(docType);
            debugPrint('Тип документа "${docType.typeName}" добавлен.');
          }
        }

        debugPrint('Локальная база данных типов документов обновлена.');
      } else {
        debugPrint(
            'Ошибка при загрузке типов документов с сервера: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Ошибка при загрузке данных с сервера: $e');
    }
  }

  // Сравнение данных типов документов
  bool _isDocTypeDataEqual(DocType localDocType, DocType serverDocType) {
    return localDocType.typeName == serverDocType.typeName;
  }
}
