import 'package:flutter/material.dart';

class Unclickable extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const Unclickable({
    required this.child,
    this.enabled = true,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: child
    );
  }
}