import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MiscCache {
  static Future<void> setFirstTimeScroll(bool scrolled) async {
    var storage = const FlutterSecureStorage();
    await storage.write(key: 'first_time_scroll', value: scrolled.toString());
  }

  static Future<bool> getFirstTimeScroll() async {
    var storage = const FlutterSecureStorage();
    var v = await storage.read(key: 'first_time_scroll');

    if (v == null || v.isEmpty) {
      return false;
    } else {
      // Otherwise, return the value
      return v == 'true';
    }
  }
}
