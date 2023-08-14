// Account cache is used to store the account information of the user
// Stored using secure storage to prevent tampering
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccountCache {
  Future<String?> _readKey(String key) async {
    final storage = new FlutterSecureStorage();
    return await storage.read(key: key);
  }

  Future<void> _writeKey(String key, String value) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: key, value: value);
  }

  Future<bool> isLoggedIn() async {
    return await _readKey('isLoggedIn') == 'true';
  }

  Future<void> setLoggedIn(bool value) async {
    await _writeKey('isLoggedIn', value.toString());
  }

  Future<String?> getToken() async {
    return await _readKey('token');
  }

  Future<void> setToken(String value) async {
    await _writeKey('token', value);
  }
}