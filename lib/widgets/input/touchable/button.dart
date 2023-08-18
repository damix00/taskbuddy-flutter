import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskbuddy/widgets/input/touchable/touchable.dart';

enum ButtonType { primary, outlined }

class Button extends StatelessWidget {
  final Widget child;
  final Function onPressed;
  final ButtonType type;
  final double? width;
  final double height;
  final double radius;

  const Button(
      {Key? key,
      required this.child,
      required this.onPressed,
      this.width,
      this.height = 40,
      this.radius = 4,
      this.type = ButtonType.primary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Touchable(
      onTap: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: type == ButtonType.primary
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.background,
            border: Border.all(
                color: Theme.of(context).colorScheme.primary, width: 1),
            borderRadius: BorderRadius.circular(radius)),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
