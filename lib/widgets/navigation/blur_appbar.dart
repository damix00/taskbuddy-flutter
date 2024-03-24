import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/state/providers/preferences.dart';

// Appbar that has a blur effect (if enabled in settings)
class BlurAppbar extends StatelessWidget {
  final Widget? child;
  final bool showLeading;
  final bool transparent;

  const BlurAppbar({
    Key? key,
    this.child,
    this.showLeading = true,
    this.transparent = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the height of the status bar and app bar
    final double statusBarHeight = MediaQuery.of(context).padding.top + 56;

    return SizedBox(
      height: statusBarHeight,
      child: Consumer<PreferencesModel>(
        builder: (context, prefs, c) {
          if (!prefs.uiBlurEnabled) {
            // If UI blur is disabled, display a non-blurred version with surface color
            return Container(
              decoration: BoxDecoration(
                color: transparent ? Theme.of(context).colorScheme.inverseSurface.withOpacity(0.5) : Theme.of(context).colorScheme.surface,
              ),
              child: _AppbarChildren(
                context: context,
                transparent: transparent,
                showLeading: showLeading,
                child: c,
              ),
            );
          }

          if (c == null) {
            return _AppbarChildren(
              context: context,
              transparent: transparent,
              showLeading: showLeading,
              child: child,
            );
          }

          return ClipRRect(
            child: BackdropFilter(
              filter:
                  ImageFilter.blur(sigmaX: 30, sigmaY: 30), // Apply blur effect
              child: Container(
                decoration: BoxDecoration(
                  color: transparent ? Theme.of(context).colorScheme.inverseSurface.withOpacity(0.5) : Theme.of(context).colorScheme.surfaceVariant,
                ),
                child: _AppbarChildren(
                  context: context,
                  transparent: transparent,
                  showLeading: showLeading,
                  child: child,
                ),
              ),
            )
          ); // Return the child as it is if available
        },
        child: child,
      ),
    );
  }

  static AppBar appBar({Widget? child, bool showLeading = true, bool transparent = false}) {
    return AppBar(
      toolbarHeight: 56,
      flexibleSpace: BlurAppbar(
        transparent: transparent,
        showLeading: showLeading,
        child: child,
      ),
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
  final bool transparent;

  const _AppbarChildren({
    Key? key,
    required this.context,
    required this.child,
    this.showLeading = false,
    this.transparent = false,
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

class AppbarTitle extends StatelessWidget {
  final String title;
  
  const AppbarTitle(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
