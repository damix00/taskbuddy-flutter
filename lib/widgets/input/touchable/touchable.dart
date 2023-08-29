import 'package:flutter/material.dart';

class Touchable extends StatefulWidget {
  final Widget child;
  final Function? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final bool disabled;

  const Touchable(
      {Key? key,
      required this.child,
      this.onTap,
      this.onLongPress,
      this.onDoubleTap,
      this.disabled = false})
      : super(key: key);

  @override
  _TouchableState createState() => _TouchableState();
}

class _TouchableState extends State<Touchable> {
  double _opacity = 1;
  Duration _duration = const Duration(milliseconds: 100);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap?.call();
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
      onDoubleTap: widget.onDoubleTap,
      onLongPress: widget.onLongPress,
      child: AnimatedOpacity(
        opacity: widget.disabled ? 0.5 : _opacity,
        duration: _duration,
        child: widget.child,
      )
    );
  }
}
