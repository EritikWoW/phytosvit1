import 'package:flutter/foundation.dart';
import 'package:phytosvit/models/user.dart';
import 'package:phytosvit/database/user_dao.dart';

class RegistrationService {
  final UserDao _userDao = UserDao();

  Future<void> registerUser(User user) async {
    try {
      await _userDao.insertUsers([user]);
    } catch (e) {
      debugPrint('Ошибка при регистрации пользователя: $e');
    }
  }
}
