import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigData {
  static double minPrice = 1;
  static double maxPrice = 10000;

  static double minRadius = 5;
  static double maxRadius = 100;

  static int minMedia = 1;
  static int maxMedia = 25;

  static Future<void> init() async {
    var remoteConfig = FirebaseRemoteConfig.instance;

    try {
      await remoteConfig.fetchAndActivate();

      minPrice = remoteConfig.getDouble('min_price');
      maxPrice = remoteConfig.getDouble('max_price');

      minRadius = remoteConfig.getDouble('min_radius');
      maxRadius = remoteConfig.getDouble('max_radius');

      minMedia = remoteConfig.getInt('min_media');
      maxMedia = remoteConfig.getInt('max_media');
    } catch (e) {
      log('Error fetching remote config: $e');
    }
  }
}