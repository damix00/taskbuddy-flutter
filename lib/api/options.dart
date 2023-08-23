import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiOptions {
  static String get baseUrl => kReleaseMode ? 'https://api.taskbuddy.net' : 'http://192.168.1.18:9500';
  static String get version => '/v1';
  static String get path => '$baseUrl$version';
  static String userAgent = '${Platform.operatingSystem}/${Platform.operatingSystemVersion}';
}