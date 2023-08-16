import 'dart:ui';

import 'package:flutter/material.dart';

class BlurAppbar extends StatelessWidget {
  final Widget? child;
  final bool showLeading;
  final bool blur;

  const BlurAppbar({
    Key? key,
    this.child,
    this.showLeading = true,
    this.blur = true,
  }) : super(key: key);

  // Render the child widget with the leading icon
  Widget renderChild(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Row(children: [
        if (showLeading)
          // The back button (aka leading icon)
          IconButton(
            iconSize: 18,
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        // Take up all the space
        Expanded(child: child ?? Container()),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the height of the status bar
    final double statusBarHeight = MediaQuery.of(context).padding.top + 56;

    // Users can disable blur in settings (for performance)
    if (!blur) {
      return SizedBox(
        height: statusBarHeight,
        child: renderChild(context),
      );
    }

    return SizedBox(
      height: statusBarHeight,
      child: ClipRRect(
        // ClipRRect is used to prevent the blur from overflowing
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              color: Theme.of(context).colorScheme.surfaceVariant,
            ),
            child: renderChild(context),
          ),
        ),
      )
    );
  }

  static AppBar appBar(
      {Widget? child, bool showLeading = true, bool blur = true}) {
    return AppBar(
      toolbarHeight: 56,
      flexibleSpace:
          BlurAppbar(showLeading: showLeading, blur: blur, child: child),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
    );
  }
}
