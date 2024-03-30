import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

class Constants {
  static const Color primaryColor = Color(0xFF1FB8FF);
  static const Color primaryColorLight = Color(0xFF136FE7);
  static const Color secondaryColor = Color(0xFF2C3F77);
  static const Color bgColor = Color(0xff201A31);
  static const Color secondaryBgColor = Color(0xFF38304D);
  static const Color borderColor = Color(0xff6E618F);

  static String? getHeadingFontFamily() {
    return Platform.isIOS
        ? 'SF Pro Display'
        : GoogleFonts.montserrat().fontFamily;
  }

  static LatLng getInitialLocation() {
    return const LatLng(42.2881519, 18.8208781);
  }
}
