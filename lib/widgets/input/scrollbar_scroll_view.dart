import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// This widget is used to automatically add a scrollbar to a SingleChildScrollView
class ScrollbarSingleChildScrollView extends StatelessWidget {
  final Widget child;

  const ScrollbarSingleChildScrollView({
    Key? key,
    required this.child,
  }) : super(key: key);

  Widget getScrollbar({required Widget child}) {
    if (Platform.isIOS) {
      return CupertinoScrollbar(
        child: child,
      );
    }
    return Scrollbar(
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return getScrollbar(
      child: SingleChildScrollView(
        child: child,
      ),
    );
  }
}
