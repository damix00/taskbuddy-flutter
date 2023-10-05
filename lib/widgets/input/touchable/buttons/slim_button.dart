import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';

class SlimButton extends StatelessWidget {
  final Widget child;
  final ButtonType type;
  final VoidCallback onPressed;

  const SlimButton({Key? key, required this.onPressed, required this.child, this.type = ButtonType.primary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      type: type,
      height: 32,
      radius: 4,
      child: child,
    );
  }
}
