// Account cache is used to store the account information of the user
// Stored using secure storage to prevent tampering
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Class responsible for caching account-related data using secure storage
class AccountCache {
  // Read a value from the storage based on a given key
  static Future<String?> _readKey(String key) async {
    var storage = const FlutterSecureStorage(); // Initialize the secure storage
    return await storage.read(key: key); // Read the value associated with the key
  }

  // Write a value to the storage based on a given key
  static Future<void> _writeKey(String key, String value) async {
    var storage = const FlutterSecureStorage(); // Initialize the secure storage
    await storage.write(key: key, value: value); // Write the value associated with the key
  }

  // Check if the user is logged in
  static Future<bool> isLoggedIn() async {
    return await _readKey('isLoggedIn') == 'true'; // Read and compare the value
  }

  // Set the logged-in status in the storage
  static Future<void> setLoggedIn(bool value) async {
    await _writeKey('isLoggedIn', value.toString()); // Write the boolean value
  }

  // Get the token from the storage
  static Future<String?> getToken() async {
    return await _readKey('token'); // Read the token value
  }

  // Set the token in the storage
  static Future<void> setToken(String value) async {
    await _writeKey('token', value); // Write the token value
  }
}