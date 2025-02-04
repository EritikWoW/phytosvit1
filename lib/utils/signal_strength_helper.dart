import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignalStrengthHelper {
  static const MethodChannel _channel =
      MethodChannel('signal_strength_channel');

  static Future<int?> getMobileSignalStrength() async {
    try {
      final int? signalStrength =
          await _channel.invokeMethod('getSignalStrength');
      return signalStrength;
    } catch (e) {
      debugPrint('Ошибка при получении уровня сигнала: $e');
      return null;
    }
  }
}
