import 'package:flutter/material.dart';

class ConditionalWrapper extends StatelessWidget {
  final bool condition;
  final Widget child;
  final Function(Widget child) wrapper;

  const ConditionalWrapper({
    required this.condition,
    required this.child,
    required this.wrapper,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return wrapper(child);
    }

    return child;
  }
}