import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:taskbuddy/widgets/ui/notification.dart';

class FirebaseMessagingApi {
  static Future<void> updateToken() async {
    String? token = await FirebaseMessaging.instance.getToken();

    print(token);
  }

  static Future<void> init() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    updateToken();

    NotificationSettings settings = await messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showOverlayNotification((ctx) =>
        CustomNotification(
          child: Center(
            child: Text(
              message.notification!.title!,
            ),
          ),
        ),
        duration: const Duration(seconds: 5)
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.data}');
    });
  }
}