import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  String apiAddress = '';
  String apiToken = "";
  String language = 'uk';
  bool isDarkTheme = false;

  // Загрузка настроек из SharedPreferences
  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    apiAddress = prefs.getString('api_address') ?? '';
    apiToken = prefs.getString('api_token') ?? '';
    language = prefs.getString('language') ?? 'uk';
    isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
  }

  Future<void> saveApiToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_token', token);
    apiToken = token;
  }

  // Сохранение API-адреса
  Future<void> saveApiAddress(String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_address', address);
    apiAddress = address;
  }

  // Сохранение выбранного языка
  Future<void> saveLanguage(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
    language = lang;
  }

  // Сохранение состояния темы
  Future<void> saveTheme(bool darkTheme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', darkTheme);
    isDarkTheme = darkTheme;
  }
}
