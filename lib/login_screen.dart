import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phytosvit/app_settings.dart';
import 'package:phytosvit/style/colors.dart';
import 'generated/l10n.dart';

// Экран для входа в систему
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  // Переменные состояния для видимости пароля и запоминания пользователя
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  // Метод для создания оформления текстового поля
  InputDecoration customInputDecoration(String labelText, Widget suffixIcon) {
    return InputDecoration(
      labelText: labelText,
      suffixIcon: suffixIcon,
      hintStyle: TextStyle(
        color: AppColors.textInputColorDay,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: AppColors.greenTeeColor,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: AppColors.inputBorderColor,
        ),
      ),
    );
  }

  // Метод для создания текстового поля ввода
  Widget _buildInputField(String label, bool isPassword) {
    return TextField(
      obscureText: isPassword &&
          !_isPasswordVisible, // Скрыть текст, если это поле пароля
      decoration: customInputDecoration(
        label,
        isPassword
            ? IconButton(
                icon: SvgPicture.asset(
                  _isPasswordVisible
                      ? 'assets/svg/icon_visible.svg'
                      : 'assets/svg/icon_invisible.svg',
                  width: 24,
                  height: 24,
                ),
                onPressed: () {
                  setState(() {
                    // Переключение видимости пароля
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : const Icon(
                Icons.person,
                color: AppColors.greenTeeColor,
              ),
      ),
    );
  }

  // Метод для создания кнопки входа
  Widget _buildSignInButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          // Действие при нажатии на кнопку входа
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.greenTeeColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          S.of(context).user_sign_in, // Текст кнопки
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Метод для создания пользовательского чекбокса "Запомнить меня"
  Widget _buildCustomCheckbox() {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Переключение состояния чекбокса
          _rememberMe = !_rememberMe;
        });
      },
      child: Row(
        children: [
          SvgPicture.asset(
            _rememberMe
                ? 'assets/svg/login_checkbox_checked.svg'
                : 'assets/svg/login_checkbox_unchecked.svg',
            width: 24,
            height: 24,
            theme: SvgTheme(currentColor: AppColors.textInputColorDay),
          ),
          const SizedBox(width: 8),
          Text(
            S.of(context).login_remember_me, // Текст чекбокса
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textColorDay,
            ),
          ),
        ],
      ),
    );
  }

  // Метод для создания кнопки "Забыл пароль?"
  Widget _buildForgotPassword() {
    return TextButton(
      onPressed: () {
        // Действие при нажатии на ссылку "Забыл пароль?"
      },
      child: Text(
        S.of(context).login_forgot_password, // Текст ссылки
        style: TextStyle(
          fontSize: 12,
          color: AppColors.yellow,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Метод для создания строки с чекбоксом и кнопкой "Забыл пароль?"
  Widget _buildRememberMeAndForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCustomCheckbox(),
        _buildForgotPassword(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Избежать наложения клавиатуры
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: AppColors.greenTeeColor, // Верхняя часть экрана
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: AppColors.lightBackgroundColor, // Нижняя часть экрана
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 109), // Отступ сверху
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      SvgPicture.asset('assets/svg/login_logo.svg'), // Логотип
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 310,
                        child: Text(
                          S.of(context).login_header_1, // Заголовок
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        S.of(context).login_header_2, // Подзаголовок
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 94),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 17.0), // Горизонтальные отступы
                  child: Container(
                    padding: const EdgeInsets.all(24), // Внутренние отступы
                    decoration: BoxDecoration(
                      color: Colors.white, // Цвет фона
                      borderRadius:
                          BorderRadius.circular(10), // Радиус скругления
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildInputField(S.of(context).user_email,
                            false), // Поле ввода email
                        const SizedBox(height: 24),
                        _buildInputField(S.of(context).user_password,
                            true), // Поле ввода пароля
                        const SizedBox(height: 24),
                        _buildRememberMeAndForgotPassword(), // Чекбокс и кнопка "Забыл пароль?"
                        const SizedBox(height: 24),
                        _buildSignInButton(), // Кнопка входа
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Переход к настройкам приложения
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AppSettings()),
          );
        },
        backgroundColor: AppColors.greenTeeColor, // Цвет кнопки
        child:
            const Icon(Icons.settings, color: Colors.white), // Иконка настроек
      ),
    );
  }
}
