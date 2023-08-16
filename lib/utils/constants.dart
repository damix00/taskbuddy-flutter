import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  static const Color primaryColor = Color(0xff0ef5e3);
  static const Color secondaryColor = Color(0xff2c3f77);
  static const Color bgColor = Color(0xff201A31);
  static const Color secondaryBgColor = Color(0xff38304d);

  static String? getHeadingFontFamily() {
    return Platform.isIOS
        ? 'SF Pro Display'
        : GoogleFonts.montserrat().fontFamily;
  }
}
