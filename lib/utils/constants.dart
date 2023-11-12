import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

class Constants {
  static const Color primaryColor = Color.fromARGB(255, 31, 184, 255);
  static const Color primaryColorLight = Color.fromARGB(255, 19, 111, 231);
  static const Color secondaryColor = Color(0xff2c3f77);
  static const Color bgColor = Color(0xff201A31);
  static const Color secondaryBgColor = Color(0xff38304d);
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
