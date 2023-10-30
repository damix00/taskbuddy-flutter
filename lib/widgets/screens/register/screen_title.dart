import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/ui/visual/gradient_text.dart';

class ScreenTitle extends StatelessWidget {
  final String title;
  final String description;
  final double spacing;

  const ScreenTitle({required this.title, required this.description, this.spacing = 12.0, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GradientText(title,
              gradient: GradientText.getDefaultGradient(context)),
          SizedBox(height: spacing),
          Text(
            description,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
