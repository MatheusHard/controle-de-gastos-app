import 'dart:async';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:controle_de_gastos_app/ui/data/service/worker/task/gastos_task.dart';
import 'package:flutter/material.dart';

import '../notifications/notifications.dart';

@pragma('vm:entry-point')
class AlarmManager {

  static const int alarmId = 1;
  static Future<void> initialize() async {
    await AndroidAlarmManager.initialize();
    await _scheduleDailyAt20();
  }

  /// Agenda para 20:00 todos os dias
  static Future<void> _scheduleDailyAt20() async {
    final now = DateTime.now();

    DateTime scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      21,
      48,
    );

    // Se já passou das 20h hoje, agenda para amanhã
    if (now.isAfter(scheduledTime)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await AndroidAlarmManager.oneShotAt(
      scheduledTime,
      alarmId,
      _executeTask,
      wakeup: true,
      rescheduleOnReboot: true,
    );

    print("⏰ Agendado para: $scheduledTime");
  }

  /// Função executada em background
  @pragma('vm:entry-point')
  static Future<void> _executeTask() async {
    print("🔥 EXECUTANDO TAREFA DAS 20:00");

    // Aqui você coloca:
    await GastosTask.contasVencidasDoDiaTask();

    // Reagenda para o próximo dia
    await _scheduleDailyAt20();
  }
}