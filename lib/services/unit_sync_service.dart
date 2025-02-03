import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:phytosvit/database/unit_dao.dart';
import 'package:phytosvit/models/unit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class UnitSyncService {
  final UnitDao unitDao;

  UnitSyncService(this.unitDao);

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
  Future<void> syncUnits() async {
    if (await _isConnectedToInternet()) {
      if (await isServerAvailable()) {
        debugPrint('Сервер доступен. Синхронизация...');
        await _fetchAndSaveUnitsFromServer();
      } else {
        debugPrint('Сервер недоступен. Работаем с локальной базой.');
      }
    } else {
      debugPrint('Нет подключения к интернету. Работаем с локальной базой.');
    }
  }

  // Загрузка данных с сервера в локальную базу данных
  Future<void> _fetchAndSaveUnitsFromServer() async {
    final url = await _getApiUrl('/units/getall');
    try {
      final response = await http.get(url, headers: await _getHeaders());

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['data'];
        List<Unit> serverUnits =
            data.map((json) => Unit.fromJson(json)).toList();

        for (var unit in serverUnits) {
          final existingUnit = await unitDao.getUnitById(unit.id!);

          if (existingUnit != null) {
            if (!_isUnitDataEqual(existingUnit, unit)) {
              await unitDao.updateUnit(unit);
              debugPrint('Единица "${unit.unitName}" обновлена.');
            } else {
              debugPrint('Данные единицы "${unit.unitName}" не изменились.');
            }
          } else {
            await unitDao.insertUnit(unit);
            debugPrint('Единица "${unit.unitName}" добавлена.');
          }
        }

        debugPrint('Локальная база данных обновлена.');
      } else {
        debugPrint(
            'Ошибка при загрузке данных с сервера: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Ошибка при загрузке данных с сервера: $e');
    }
  }

  // Сравнение данных единиц
  bool _isUnitDataEqual(Unit localUnit, Unit serverUnit) {
    return localUnit.unitName == serverUnit.unitName;
  }
}
