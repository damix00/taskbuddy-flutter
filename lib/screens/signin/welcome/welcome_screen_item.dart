import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:taskbuddy/widgets/ui/gradient_text.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class WelcomeScreenItem extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const WelcomeScreenItem(
      {Key? key,
      required this.title,
      required this.description,
      required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 300,
            child: Image.asset(image),
          ),
          const SizedBox(height: 12),
          GradientText(title,
              gradient: LinearGradient(
                colors: [
                  // If the device is in dark mode use actual colors for the gradients
                  // Black is used in light mode because the gradient doesn't look good in light mode
                  brightness == Brightness.dark ? Theme.of(context).colorScheme.secondary : Colors.black,
                  brightness == Brightness.dark ? Theme.of(context).colorScheme.primary : Colors.black,
                ],
              )),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
