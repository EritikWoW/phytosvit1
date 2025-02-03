import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  ThemeData _themeData = ThemeData.light();

  ThemeProvider(bool isDarkTheme); // Инициализация по умолчанию

  void toggleTheme(bool isDark) {
    if (_isDarkTheme != isDark) {
      // Проверка на изменения
      _isDarkTheme = isDark;
      _themeData =
          isDark ? ThemeData.dark() : ThemeData.light(); // Обновление themeData
      notifyListeners();
    }
  }

  ThemeData get themeData => _themeData; // Возвращаем кэшированный объект
}
