import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart'; // útil para pedir permissões

class Notifications {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initNotifications() async {
    const AndroidInitializationSettings androidInitSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
    InitializationSettings(android: androidInitSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings);

    // 🔑 Solicitar permissão no Android 13+
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'default_channel_id',
      'Notificações padrão',
      channelDescription: 'Canal para notificações básicas',
      importance: Importance.max,
      priority: Priority.high,
      );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }
}