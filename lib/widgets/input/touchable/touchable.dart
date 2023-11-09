import 'package:flutter/material.dart';
import 'package:taskbuddy/utils/utils.dart';

class Touchable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final bool disabled;
  final bool enableAnimation;

  const Touchable(
      {Key? key,
      required this.child,
      this.onTap,
      this.onLongPress,
      this.onDoubleTap,
      this.enableAnimation = true,
      this.disabled = false})
      : super(key: key);

  @override
  _TouchableState createState() => _TouchableState();
}

class _TouchableState extends State<Touchable> {
  double _opacity = 1;
  Duration _duration = const Duration(milliseconds: 100);

  bool _shouldCallTap = true;
  Offset _startPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque, // Used to make the empty space clickable
      onPointerDown: (e) {
        setState(() {
          if (!widget.enableAnimation) return;
          _opacity = 0.5;
          _duration = Duration.zero;
        });

        _startPosition = e.position;

        _shouldCallTap = true;
      },
      onPointerUp: (e) {
        if (!widget.enableAnimation) return;
        setState(() {
          _opacity = 1;
          _duration = const Duration(milliseconds: 100);
        });

        if (_shouldCallTap && widget.onTap != null) {
          widget.onTap?.call();
        }
      },
      onPointerCancel: (e) {
        if (!widget.enableAnimation) return;
        setState(() {
          _opacity = 1;
          _duration = const Duration(milliseconds: 100);
        });

        _shouldCallTap = false;
      },
      onPointerMove: (e) {
        // Check distance between start and end position
        if (Utils.dist(_startPosition, e.position) < 10) {
          return;
        }

        // if it is moved too much, cancel the tap
        if (!widget.enableAnimation) return;
        setState(() {
          _opacity = 1;
          _duration = const Duration(milliseconds: 100);
        });

        _startPosition = Offset.zero;
        _shouldCallTap = false;
      },
      // onDoubleTap: () {
      //   if (widget.disabled) return;

      //   widget.onDoubleTap?.call();
      // },
      // onLongPress: () {
      //   if (widget.disabled) return;

      //   widget.onLongPress?.call();
      // },
      child: AnimatedOpacity(
        opacity: widget.disabled ? 0.5 : _opacity,
        duration: _duration,
        child: widget.child,
      )
    );
  }
}
