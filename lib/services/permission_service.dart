import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PermissionService {
  // Запрос разрешений
  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      // Разрешение предоставлено
      _showPermissionStatus('Разрешение предоставлено');
    } else if (status.isDenied) {
      // Разрешение отклонено
      _showPermissionStatus('Разрешение отклонено');
    } else if (status.isPermanentlyDenied) {
      // Разрешение отклонено навсегда
      _showPermissionStatus('Разрешение отклонено навсегда');
      // Открыть настройки для предоставления разрешений вручную
      openAppSettings();
    }
  }

  // Показать статус разрешений (можно заменить на другие действия)
  void _showPermissionStatus(String message) {
    // Можно заменить на более подходящий вид для твоего приложения
    debugPrint(message);
  }

  // Проверить текущий статус разрешения
  Future<bool> isLocationPermissionGranted() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }
}
