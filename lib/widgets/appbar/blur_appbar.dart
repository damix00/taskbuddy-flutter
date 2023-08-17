import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/providers/preferences.dart';

class BlurAppbar extends StatelessWidget {
  final Widget? child;
  final bool showLeading;

  const BlurAppbar({
    Key? key,
    this.child,
    this.showLeading = true,
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
            color: Theme.of(context).colorScheme.onBackground,
          ),
        // Take up all the space
        Expanded(child: child ?? Container()),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the height of the status bar and app bar
    final double statusBarHeight = MediaQuery.of(context).padding.top + 56;

    return SizedBox(
      height: statusBarHeight,
      child: Consumer<PreferencesModel>(
        builder: (context, prefs, child) {
          if (!prefs.uiBlurEnabled) {
            // If UI blur is disabled, display a non-blurred version with surface color
            return Container(
              child: renderChild(context),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
              ),
            );
          }

          if (child == null) return renderChild(context);

          return child; // Return the child as it is if available
        },
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), // Apply blur effect
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              child: renderChild(context),
            ),
          ),
        ),
      ),
    );
  }

  static AppBar appBar(
      {Widget? child, bool showLeading = true}) {
    return AppBar(
      toolbarHeight: 56,
      flexibleSpace:
          BlurAppbar(showLeading: showLeading, child: child),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
    );
  }
}
