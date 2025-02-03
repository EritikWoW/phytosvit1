import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:phytosvit/models/user.dart';
import 'package:phytosvit/services/settings_service.dart';
import 'package:phytosvit/database/user_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class UserSyncService {
  final UserDao userDao;
  final SettingsService settingsService;

  UserSyncService(this.settingsService, this.userDao);

  // Проверка подключения к интернету
  Future<bool> _isConnectedToInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Проверка доступности сервера
  Future<bool> isServerAvailable() async {
    final url = await _getApiUrl(
        '/ping'); // Предполагаем, что сервер имеет эндпоинт для проверки доступности
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
  Future<void> syncUsers() async {
    if (await _isConnectedToInternet()) {
      if (await isServerAvailable()) {
        debugPrint('Сервер доступен. Синхронизация...');
        await _fetchAndSaveUsersFromServer();
        await _uploadLocalUsersToServer();
      } else {
        debugPrint('Сервер недоступен. Работаем с локальной базой.');
      }
    } else {
      debugPrint('Нет подключения к интернету. Работаем с локальной базой.');
    }
  }

  // Загрузка данных с сервера в локальную базу данных
  Future<void> _fetchAndSaveUsersFromServer() async {
    final url = await _getApiUrl('/users/getall');
    try {
      final response = await http.get(url, headers: await _getHeaders());

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['data'];
        List<User> serverUsers =
            data.map((json) => User.fromJson(json)).toList();

        for (var user in serverUsers) {
          final existingUser = await userDao.getUserByEmail(user.userEmail);

          if (existingUser != null) {
            if (!_isUserDataEqual(existingUser, user)) {
              user.setId(existingUser.id);
              await userDao.updateUser(user);
              debugPrint('Пользователь с email ${user.userEmail} обновлен.');
            } else {
              debugPrint(
                  'Данные пользователя ${user.userEmail} не изменились.');
            }
          } else {
            await userDao.insertUser(user);
            debugPrint('Пользователь с email ${user.userEmail} добавлен.');
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

  // Загрузка локальных данных на сервер
  Future<void> _uploadLocalUsersToServer() async {
    final url = await _getApiUrl('/users/create');
    List<User> localUsers = await userDao.getUsers();

    for (var user in localUsers) {
      try {
        final response = await http.post(
          url,
          headers: await _getHeaders(),
          body: json.encode(user.toJson()),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint(
              'Пользователь ${user.userEmail} синхронизирован с сервером.');
        } else {
          String message = json.decode(response.body)['message'];
          debugPrint(
              'Ошибка при отправке пользователя ${user.userEmail}: $message');
        }
      } catch (e) {
        debugPrint('Ошибка при отправке данных на сервер: $e');
      }
    }
  }

  // Получение пользователя по email
  Future<User?> getUserByEmail(String email) async {
    email = email.trim();
    final url = await _getApiUrl('/users/byemail/$email');
    try {
      final response = await http.get(url, headers: await _getHeaders());

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody.containsKey('data') && responseBody['data'] != null) {
          final data = responseBody['data'];

          if (data is Map<String, dynamic>) {
            return User.fromJson(data);
          } else {
            debugPrint('Ошибка: некорректный формат данных в поле "data".');
            return null;
          }
        } else {
          debugPrint('Ошибка: данные с сервера пустые или некорректные.');
          return null;
        }
      } else if (response.statusCode == 404) {
        debugPrint('Пользователь с email $email не найден.');
        return null;
      } else {
        debugPrint(
            'Ошибка при запросе пользователя: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Ошибка подключения: $e');
      return null;
    }
  }

  // Сравнение данных пользователя
  bool _isUserDataEqual(User localUser, User serverUser) {
    return localUser.userName == serverUser.userName &&
        localUser.userSurname == serverUser.userSurname &&
        localUser.userBirthDay == serverUser.userBirthDay &&
        localUser.userEmail == serverUser.userEmail &&
        localUser.userPassword == serverUser.userPassword &&
        localUser.userRole == serverUser.userRole &&
        localUser.userPhone == serverUser.userPhone &&
        localUser.userPhoto == serverUser.userPhoto;
  }
}
