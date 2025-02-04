import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PasswordEncryptorUtils {
  // Получаем ключ из .env и приводим его к необходимой длине (16, 24 или 32 байта)
  static final encrypt.Key key = encrypt.Key.fromUtf8(_getSecretKey());
  static final encrypt.IV initVector =
      encrypt.IV.fromUtf8(_getInitVector()); // 16 байт

  // Метод для получения правильного ключа (если длина меньше 16 байт)
  static String _getSecretKey() {
    String secretKey = dotenv.env['SECRET_KEY'] ?? '';
    if (secretKey.length < 16) {
      // Дополняем строку до 16 байт, если она меньше
      return secretKey.padRight(16, '0'); // Добавляем нули до длины 16
    } else if (secretKey.length > 16 && secretKey.length <= 24) {
      // Приводим к 16 байт, если длина 24 байта
      return secretKey.substring(0, 16);
    } else if (secretKey.length > 24 && secretKey.length <= 32) {
      // Приводим к 24 байт, если длина 32 байта
      return secretKey.substring(0, 24);
    } else {
      // Если длина больше 32 байт, то обрезаем до 32 байт
      return secretKey.substring(0, 32);
    }
  }

  // Метод для получения правильного IV (если длина меньше 16 байт)
  static String _getInitVector() {
    String initVector = dotenv.env['INIT_VECTOR'] ?? '';
    if (initVector.length < 16) {
      // Дополняем строку до 16 байт, если она меньше
      return initVector.padRight(16, '0'); // Добавляем нули до длины 16
    } else if (initVector.length > 16) {
      // Обрезаем строку до 16 байт, если она больше
      return initVector.substring(0, 16);
    }
    return initVector;
  }

  // Метод для шифрования пароля
  static String encryptPassword(String password) {
    try {
      // Настроим шифратор
      final encrypter = encrypt.Encrypter(
          encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

      // Зашифровать пароль
      final encrypted = encrypter.encrypt(password, iv: initVector);

      // Возвращаем зашифрованный пароль в формате Base64
      return encrypted.base64;
    } catch (e) {
      debugPrint("Ошибка при шифровании: $e");
      return "";
    }
  }

  // Метод для расшифровки пароля
  static String decryptPassword(String encryptedPassword) {
    try {
      // Настроим расшифровщик
      final encrypter = encrypt.Encrypter(
          encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

      // Расшифровать пароль
      final decrypted = encrypter.decrypt(
          encrypt.Encrypted.fromBase64(encryptedPassword),
          iv: initVector);

      return decrypted;
    } catch (e) {
      debugPrint("Ошибка при расшифровке: $e");
      return "";
    }
  }
}
