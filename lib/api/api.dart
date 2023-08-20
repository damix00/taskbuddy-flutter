import 'dart:io';

import 'package:taskbuddy/api/v1/v1.dart';

class Api {
  static String get baseUrl => 'https://api.taskbuddy.net';
  static String get version => '/v1';
  static String get path => '$baseUrl$version';
  static String userAgent = '${Platform.operatingSystem}/${Platform.operatingSystemVersion}';

  static V1 get v1 => V1();
}