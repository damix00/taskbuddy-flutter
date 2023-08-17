import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesConfig {
  static Future<bool> readBool(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Blur is enabled by default on iOS due to poor performance on Android
    return prefs.getBool(key) ?? Platform.isIOS;
  }

  static Future<bool> isUiBlurEnabled() async{
    return await readBool('ui_blur_enabled');
  }
}