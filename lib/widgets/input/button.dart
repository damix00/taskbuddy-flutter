import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/utils/constants.dart';

enum ButtonType { primary, outlined }

class Button extends StatefulWidget {
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
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  double _opacity = 1;
  Duration _duration = const Duration(milliseconds: 100);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed();
      },
      onTapDown: (_) {
        setState(() {
          _opacity = 0.5;
          _duration = Duration.zero;
        });
      },
      onTapUp: (_) {
        setState(() {
          _opacity = 1;
          _duration = const Duration(milliseconds: 100);
        });
      },
      onTapCancel: () {
        setState(() {
          _opacity = 1;
          _duration = const Duration(milliseconds: 100);
        });
      },
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: _duration,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
              color: widget.type == ButtonType.primary
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.background,
              border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1),
              borderRadius: BorderRadius.circular(widget.radius)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Center(
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
