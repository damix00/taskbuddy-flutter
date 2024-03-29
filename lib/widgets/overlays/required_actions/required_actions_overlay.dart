import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/state/providers/auth.dart';
import 'package:taskbuddy/utils/error_codes.dart';
import 'package:taskbuddy/widgets/overlays/required_actions/update_app.dart';
import 'package:taskbuddy/widgets/overlays/required_actions/verify_phone/verify_phone.dart';

class _RequiredActionsMap extends StatelessWidget {
  final AuthModel auth;

  const _RequiredActionsMap({Key? key, required this.auth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (auth.requiredActions == null) {
      return Container();
    }

    if (auth.requiredActions!.updateApp || auth.requiredActions!.verifyEmail) {
      return UpdateApp(
        errorCode: auth.requiredActions!.updateApp
            ? ErrorCodes.outdatedVersion
            : ErrorCodes.unsupportedRequiredAction
      );
    }

    if (auth.requiredActions!.verifyPhoneNumber) {
      return const VerifyPhoneNumber();
    }

    OverlaySupportEntry.of(context)!.dismiss(); // Close the popup

    return Container();
  }
}

class RequiredActionsOverlay extends StatelessWidget {
  const RequiredActionsOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Disable the back button on android
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        // blur everything behind the overlay
        child: ClipRRect(
            child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: Container(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Consumer<AuthModel>(
              builder: (context, auth, child) {
                return _RequiredActionsMap(auth: auth);
              },
            ),
          ),
        )),
      ),
    );
  }
}
