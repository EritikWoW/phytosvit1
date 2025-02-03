import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('uk');

  LocaleProvider(String language);
  Locale get locale => _locale;

  void changeLocale(String languageCode) {
    if (_locale.languageCode != languageCode) {
      // Проверка на изменения
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }
}
