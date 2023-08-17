import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/input/touchable/touchable.dart';

enum ButtonType { primary, outlined }

class Button extends StatelessWidget {
  Widget child;
  Function onPressed;
  ButtonType type;
  double? width;
  double? height;
  double radius = 4;

  Button(
      {Key? key,
      required this.child,
      required this.onPressed,
      this.type = ButtonType.primary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Touchable(
        onTap: onPressed,
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
      ),
    );
  }
}