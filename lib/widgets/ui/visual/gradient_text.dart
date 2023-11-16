import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

class GradientText extends StatelessWidget {
  final String text;
  final Gradient gradient;

  const GradientText(this.text, {Key? key, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      // Use Text as a mask to show the gradient
      shaderCallback: (bounds) {
        return gradient.createShader(bounds);
      },
      blendMode: BlendMode.srcIn,
      child: Text(
        text,
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w900, fontSize: 40, height: 1.3),
        textAlign: TextAlign.center,
      ),
    );
  }

  static LinearGradient getDefaultGradient(BuildContext context) {
    Brightness brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;

    return LinearGradient(
      colors: [
        // If the device is in dark mode use actual colors for the gradients
        // Black is used in light mode because the gradient doesn't look good in light mode
        brightness == Brightness.dark
            ? Theme.of(context).colorScheme.secondary
            : Colors.black,
        brightness == Brightness.dark
            ? Theme.of(context).colorScheme.primary
            : Colors.black,
      ],
    );
  }
}
