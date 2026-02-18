import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

class AppBackgroundService {

  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart, // 👈 função GLOBAL
        autoStart: true,
        isForegroundMode: true,
        notificationChannelId: 'my_foreground',
        initialNotificationTitle: 'Controle de Gastos',
        initialNotificationContent: 'Serviço rodando em background',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(),
    );
  }
}

/// 👇 FUNÇÃO GLOBAL (OBRIGATÓRIA)
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {

  if (service is AndroidServiceInstance) {
    service.setForegroundNotificationInfo(
      title: "Controle de Gastos",
      content: "Executando tarefa em background",
    );
  }

  Timer.periodic(const Duration(seconds: 10), (timer) async {
    print("🔥 BACKGROUND RODANDO");
  });
}