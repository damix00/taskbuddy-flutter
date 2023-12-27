import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/widgets/ui/notification.dart';

class FirebaseMessagingApi {
  static Future<void> updateToken() async {
    // Get the firebase token
    String? token = await FirebaseMessaging.instance.getToken();

    // Log it
    log('FirebaseMessaging token: $token');

    // Send it to server
    if (token == null) {
      return;
    }

    String accountToken = (await AccountCache.getToken())!;

    await Api.v1.accounts.meRoute.updateFCMToken(accountToken, token);
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

    FirebaseMessaging.onBackgroundMessage((message) async {
      print('Handling a background message ${message.messageId}');
      print(message.notification?.title);
    });
  }
}