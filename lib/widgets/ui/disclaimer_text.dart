import 'package:flutter/material.dart';

class DisclaimerText extends StatelessWidget {
  final String text;

  const DisclaimerText({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontSize: 12,
      ),
    );
  }
}