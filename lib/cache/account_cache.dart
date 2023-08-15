// Account cache is used to store the account information of the user
// Stored using secure storage to prevent tampering
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccountCache {
  static Future<String?> _readKey(String key) async {
    final storage = new FlutterSecureStorage();
    return await storage.read(key: key);
  }

  static Future<void> _writeKey(String key, String value) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: key, value: value);
  }

  static Future<bool> isLoggedIn() async {
    return await _readKey('isLoggedIn') == 'true';
  }

  static Future<void> setLoggedIn(bool value) async {
    await _writeKey('isLoggedIn', value.toString());
  }

  static Future<String?> getToken() async {
    return await _readKey('token');
  }

  static Future<void> setToken(String value) async {
    await _writeKey('token', value);
  }
}