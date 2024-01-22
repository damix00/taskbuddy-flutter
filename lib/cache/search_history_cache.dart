import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SearchHistoryCache {
  static Future<void> setHistory(List<String> terms) async {
    var storage = const FlutterSecureStorage();
    await storage.write(key: 'search_history', value: jsonEncode(terms));
  }

  static Future<List<String>> getHistory() async {
    var storage = const FlutterSecureStorage();
    var v = await storage.read(key: 'search_history');

    if (v == null || v.isEmpty) {
      // If the value is empty, then return null
      return [];
    } else {
      // Otherwise, return the value
      List<dynamic> l = jsonDecode(v);

      return l.map((e) => e.toString()).toList().reversed.toList();
    }
  }
}
