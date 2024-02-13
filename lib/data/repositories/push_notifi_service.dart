import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/data/repositories/local_notifications.dart';
import 'package:ipicku_dating_app/main.dart';
import 'package:http/http.dart' as http;
import 'package:ipicku_dating_app/presentation/chatpage/chatpage.dart';
import 'package:ipicku_dating_app/presentation/homepage/notifications_page.dart';
import 'package:ipicku_dating_app/presentation/profile/pages/mypicks.dart';

@pragma('vm:entry-point')
Future<void> handleBackground(RemoteMessage message) async {
  debugPrint('Handling a background message ${message.notification?.title}');
  debugPrint('Handling a background message ${message.notification?.body}');
  debugPrint('Handling a background message ${message.data}');
  NotificationService().showNotification(notification: message.data);
}

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    final data = message.data;
    String? notificationContent = data['notificationContent'];

    // Use the extracted information to navigate to the appropriate page
     navigatorKey.currentState
        ?.pushNamed(NotificationsPage.route, arguments: notificationContent);
  }

  Future initPushNotification() async {
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: false,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onMessage.listen((message) {
      handleMessage(message);
      NotificationService().showNotification(notification: message.data);
    });
    FirebaseMessaging.onBackgroundMessage(handleBackground);
  }

  void showNotificationtoUSer() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      sound: false,
      announcement: false,
      badge: false,
      criticalAlert: false,
      provisional: false,
    );
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: false,
      badge: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint("User granted provisional permission");
    } else {
      debugPrint("User denied permission");
    }
  }

  void sendPushMessage(
      {required String token,
      required String body,
      required String type,
      required String title}) async {
    final response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization':
                  'key=AAAAbcysiTw:APA91bFgCLKREmnlYO2FOd1Dw16lnc8fGrtSmLtZg-0wLVnu4sk0QSd6lOzJ6xdfzheuPiva5rff3G-wmfonx_H9eUC3_jb5c3RafwEaQiiPDEGHIAktf6tQwhQkWZ5Ic-S5GfO7pY_0'
            },
            encoding: Encoding.getByName('utf-8'),
            body: jsonEncode(<String, dynamic>{
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
                'body': body,
                'title': title,
                'notificationType': type
              },
              "notification": <String, dynamic>{
                "title": title,
                "body": body,
              },
              "to": token,
            }));

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint("Success ${response.statusCode} to $token");
    } else {
      debugPrint("Failed Notification");
    }
  }
}
