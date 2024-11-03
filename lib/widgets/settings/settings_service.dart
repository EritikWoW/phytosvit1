import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  Future<Map<String, dynamic>> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'api_address': prefs.getString('api_address') ?? '',
      'language': prefs.getString('language') ?? 'uk',
      'isDarkTheme': prefs.getBool('isDarkTheme') ?? false,
    };
  }

  Future<void> saveSettings(
      {required String apiAddress,
      required String language,
      required bool isDarkTheme}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_address', apiAddress);
    await prefs.setString('language', language);
    await prefs.setBool('isDarkTheme', isDarkTheme);
  }
}
