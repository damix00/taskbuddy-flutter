import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/state/providers/auth.dart';
import 'package:taskbuddy/utils/error_codes.dart';
import 'package:taskbuddy/widgets/overlays/required_actions/update_app.dart';
import 'package:taskbuddy/widgets/overlays/required_actions/verify_phone.dart';

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
                return !auth.finishedLoading
                    ? const Center(child: CircularProgressIndicator())
                    : (
                        auth.requiredActions!.verifyEmail
                          ? UpdateApp(errorCode: ErrorCodes.unsupportedRequiredAction)
                          : const VerifyPhoneNumber()
                    );
              },
            ),
          ),
        )),
      ),
    );
  }
}
