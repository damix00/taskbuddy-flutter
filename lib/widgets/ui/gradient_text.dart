import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GradientText extends StatelessWidget {
  final String text;
  final Gradient gradient;

  const GradientText(this.text, {Key? key, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      blendMode: BlendMode.srcIn,
      child: Text(
        text,
        style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 40, height: 1.3),
        textAlign: TextAlign.center,
      ),
    );
  }
}