import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationService =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: null, macOS: null);

    await _notificationService.initialize(
      initializationSettings,
    );
  }

  notificationDetails() => const NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'channelName',
          importance: Importance.max));
  Future showNotification(
      {int id = 0, required Map<String, dynamic> notification}) async {
    await _notificationService.show(id, notification['title'] ?? '',
        notification['body'] ?? '', await notificationDetails());
  }
}
