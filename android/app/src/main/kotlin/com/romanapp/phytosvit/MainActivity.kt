package com.romanapp.phytosvit

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.telephony.CellInfo
import android.telephony.CellInfoLte
import android.telephony.CellSignalStrength
import android.telephony.TelephonyManager

class MainActivity : FlutterActivity() {
    private val CHANNEL = "signal_strength_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getSignalStrength") {
                val signalStrength = getSignalStrength()
                if (signalStrength != null) {
                    result.success(signalStrength)
                } else {
                    result.error("UNAVAILABLE", "Не удалось получить уровень сигнала", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getSignalStrength(): Int? {
        try {
            // Получаем TelephonyManager
            val telephonyManager = getSystemService(TELEPHONY_SERVICE) as TelephonyManager

            // Получаем список информации о сотах
            val cellInfoList: List<CellInfo>? = telephonyManager.allCellInfo

            // Если список пуст или null, возвращаем null
            if (cellInfoList.isNullOrEmpty()) {
                return null
            }

            // Ищем уровень сигнала для LTE
            for (cellInfo in cellInfoList) {
                if (cellInfo is CellInfoLte) {
                    val signalStrength: CellSignalStrength = cellInfo.cellSignalStrength
                    return signalStrength.dbm // Уровень сигнала в dBm
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }

        // Если сигнал не найден, возвращаем null
        return null
    }
}