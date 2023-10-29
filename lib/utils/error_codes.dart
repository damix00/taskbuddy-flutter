import 'dart:io';

class ErrorCodes {
  static String get outdatedVersion {
    return "0x${Platform.isAndroid ? "0" : "1"}1";
  }

  static String get unknown {
    return "0x${Platform.isAndroid ? "0" : "1"}2";
  }

  static String get unsupportedRequiredAction {
    return "0x${Platform.isAndroid ? "0" : "1"}3";
  }
}
