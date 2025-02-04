import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:phytosvit/database/user_dao.dart';
import 'package:phytosvit/services/user_sync_service.dart';
import 'package:phytosvit/utils/password_encryptor_widget.dart';
import '../generated/l10n.dart';
import '../models/user.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserDao userDao;
  final UserSyncService syncService;

  bool isPasswordVisible = false;
  bool rememberMe = false;
  String? errorMessage;
  bool isServerAvailable = false;

  LoginViewModel({required this.userDao, required this.syncService});

  // Проверка подлинности пользователя
  Future<bool> authenticateUser(BuildContext context) async {
    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text.trim();

    try {
      // Проверяем доступность сервера
      isServerAvailable = await checkServerAvailability();

      // Получаем пользователя либо с сервера, либо из локальной базы
      final user = await fetchUserByEmail(email, isServerAvailable);

      if (user != null) {
        final isPasswordCorrect =
            PasswordEncryptorUtils.decryptPassword(user.userPassword) ==
                password;

        if (isPasswordCorrect) {
          if (rememberMe) {
            await saveUserSession(email); // Сохраняем сессию
          }
          clearError();
          return true;
        } else {
          setError(S.of(context).error_invalid_password);
        }
      } else {
        setError(S.of(context).error_user_not_found);
      }
    } catch (e) {
      debugPrint('Ошибка аутентификации: $e');
      setError(S.of(context).error_generic); // Общая ошибка
    }
    return false;
  }

  Future<void> autoLogin(BuildContext context) async {
    final email = await checkUserSession();
    if (email != null) {
      // Пытаемся найти пользователя в локальной базе данных
      final user = await userDao.getUserByEmail(email);

      if (user != null) {
        // Успешный автоматический вход
        Navigator.pushReplacementNamed(
            context, '/main'); // Перенаправляем на главный экран
      } else {
        // Если пользователя нет в базе, очищаем сессию
        await clearUserSession();
        setError(S.of(context).error_user_not_found);
      }
    }
  }

  // Проверка доступности сервера
  Future<bool> checkServerAvailability() async {
    try {
      final isOnline = await Connectivity().checkConnectivity();
      if (isOnline == ConnectivityResult.none) {
        debugPrint('Сеть недоступна');
        return false;
      }
      return await syncService.isServerAvailable();
    } catch (e) {
      debugPrint('Ошибка проверки сервера: $e');
      return false;
    }
  }

  // Получение пользователя по email
  Future<User?> fetchUserByEmail(String email, bool isServerAvailable) async {
    try {
      return isServerAvailable
          ? await syncService.getUserByEmail(email)
          : await userDao.getUserByEmail(email);
    } catch (e) {
      debugPrint('Ошибка получения пользователя: $e');
      return null;
    }
  }

  // Сохранение сессии пользователя
  Future<void> saveUserSession(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
  }

  // Проверка сессии пользователя
  Future<String?> checkUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  // Очистка сессии пользователя
  Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
  }

  // Установка ошибки
  void setError(String message) {
    errorMessage = message;
    notifyListeners();
  }

  // Очистка ошибки
  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  // Переключение видимости пароля
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  // Переключение состояния чекбокса "Запомнить меня"
  void toggleRememberMe() {
    rememberMe = !rememberMe;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
