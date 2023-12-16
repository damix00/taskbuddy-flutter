import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// This widget is used to automatically add a scrollbar to a SingleChildScrollView
class ScrollbarSingleChildScrollView extends StatelessWidget {
  final Widget child;
  final ScrollController? controller;

  const ScrollbarSingleChildScrollView({
    Key? key,
    required this.child,
    this.controller,
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
        controller: controller,
        child: child,
      ),
    );
  }
}
