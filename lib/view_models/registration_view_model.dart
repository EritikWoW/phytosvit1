import 'package:flutter/material.dart';
import 'package:phytosvit/database/user_dao.dart';
import 'package:phytosvit/models/user.dart';
import 'package:phytosvit/widgets/password_encryptor_widget.dart';

class RegistrationViewModel with ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final UserDao userDao;

  RegistrationViewModel({required this.userDao});

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Имя не должно быть пустым';
    }
    return null;
  }

  String? validateEmail(String? value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (value == null || value.isEmpty) {
      return 'Email не должно быть пустым';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Неправильный формат Email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пароль не должен быть пустым';
    }
    if (value.length < 8 ||
        !RegExp(r'(?=.*[a-z])(?=.*[A-Z])(?=.*\W)').hasMatch(value)) {
      return 'Пароль должен быть не менее 8 символов, содержать заглавную, строчную буквы и специальный символ';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value != passwordController.text) {
      return 'Пароли не совпадают';
    }
    return null;
  }

  Future<void> submitForm() async {
    if (formKey.currentState?.validate() ?? false) {
      final encryptedPassword =
          PasswordEncryptorUtils.encryptPassword(passwordController.text);

      final user = User.registration(
        userName: nameController.text,
        userEmail: emailController.text.toLowerCase(),
        userPassword: encryptedPassword,
      );

      await userDao.insertUser(user); // Сохранение в локальную БД
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
