import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:taskbuddy/widgets/ui/notification.dart';

class SnackbarPresets {
  static void show(BuildContext context, { required String text, Color? backgroundColor, Color? textColor }) {
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Text(
    //     text,
    //     style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
    //   ),
    //   behavior: SnackBarBehavior.floating,
    //   margin: const EdgeInsets.all(16),
    //   backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
    // ));
    showOverlayNotification((ctx) =>
      CustomNotification(
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.background,
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: textColor ?? Theme.of(context).colorScheme.onSurface),
          ),
        ),
      ),
      position: NotificationPosition.bottom,
      duration: const Duration(seconds: 5)
    );
  }

  static void error(BuildContext context, String text) {
    show(context, text: text, backgroundColor: Theme.of(context).colorScheme.error, textColor: Theme.of(context).colorScheme.onError);
  }

  static void networkError(BuildContext context) {
    error(context, AppLocalizations.of(context)!.networkError);
  }
}
