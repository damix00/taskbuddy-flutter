import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppOverlay extends ChangeNotifier {
  Widget? _overlay; // Internal variable to store the current overlay widget

  Widget? get overlay => _overlay; // Get the overlay

  // Method to set the overlay
  set overlay(Widget? overlay) {
    _overlay = overlay; // Update the internal value
    notifyListeners(); // Notify listeners of the change
  }
}

class AppOverlayWidget extends StatelessWidget {
  final Widget? child;

  const AppOverlayWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppOverlay>(
      builder: (context, appOverlay, child) {
        return Stack(
          children: [
            child!,
            if (appOverlay.overlay != null) appOverlay.overlay!,
          ],
        );
      },
      child: child,
    );
  }
}