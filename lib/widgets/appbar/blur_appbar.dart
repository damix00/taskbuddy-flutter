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
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
              ),
              child: _AppbarChildren(
                context: context,
                showLeading: showLeading,
                child: child,
              ),
            );
          }

          if (child == null) {
            return _AppbarChildren(
              context: context,
              showLeading: showLeading,
              child: child,
            );
          }

          return child; // Return the child as it is if available
        },
        child: ClipRRect(
          child: BackdropFilter(
            filter:
                ImageFilter.blur(sigmaX: 50, sigmaY: 50), // Apply blur effect
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              child: _AppbarChildren(
                context: context,
                showLeading: showLeading,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static AppBar appBar({Widget? child, bool showLeading = true}) {
    return AppBar(
      toolbarHeight: 56,
      flexibleSpace: BlurAppbar(showLeading: showLeading, child: child),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
    );
  }
}

class _AppbarChildren extends StatelessWidget {
  final BuildContext context;
  final Widget? child;
  final bool showLeading;

  const _AppbarChildren({
    Key? key,
    required this.context,
    required this.child,
    this.showLeading = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
