import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/state/providers/preferences.dart';

class BlurParent extends StatefulWidget {
  final Widget child;
  final double height;
  final bool forceDisableBlur;

  const BlurParent({this.forceDisableBlur = false, required this.child, required this.height, Key? key}) : super(key: key);

  @override
  State<BlurParent> createState() => _BlurParentState();
}

class _BlurParentState extends State<BlurParent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Consumer<PreferencesModel>(
        builder: (context, prefs, child) {
          var noBlurChild = Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: widget.child,
          );

          if (widget.forceDisableBlur) {
            return noBlurChild;
          }

          if (!prefs.uiBlurEnabled) {
            return noBlurChild;
          }

          // assume blur is disabled
          if (child == null) {
            return noBlurChild;
          }

          return child;
        },

        // The child is with blur
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              child: widget.child,
            ),
          ),
        ),
      )
    );
  }
}