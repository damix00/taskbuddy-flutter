import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/account_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/widgets/input/with_state/text_inputs/otp_input.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/link_text.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:taskbuddy/widgets/ui/feedback/snackbars.dart';

class _CodeInput extends StatefulWidget {
  final Function(String) onCompleted;

  const _CodeInput({required this.onCompleted, Key? key}) : super(key: key);

  @override
  State<_CodeInput> createState() => _CodeInputState();
}

class _CodeInputState extends State<_CodeInput> {
  int _countdown = 30;
  Timer? _timer;

  void _startTimer() {
    if (_timer != null) _timer!.cancel();

    setState(() {
      _countdown = 30;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
      });

      if (_countdown == 0) {
        _timer!.cancel();
        _timer = null;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OTPInput(
          title: l10n.verificationCode,
          width: 46,
          height: 46,
          onCompleted: (value) {
            widget.onCompleted(value);
          },
        ),
        const SizedBox(height: 8),
        LinkText(
          disabled: _countdown > 0,
          text: _countdown > 0 ? l10n.resendCodeIn(_countdown) : l10n.resendCode,
          onTap: () async {
            await Api.v1.accounts.verification.phone.send((await AccountCache.getToken())!);
            SnackbarPresets.show(
              context,
              text: l10n.verificationCodeSent
            );
            _startTimer();
          },
        ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  final Function(String) onCompleted;

  const _Title({required this.onCompleted, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.enterVerificationCode,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.enterVerificationCodeDesc,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        _CodeInput(onCompleted: onCompleted,),
      ],
    );
  }
}

class VerifyPhoneSecondPage extends StatefulWidget {

  const VerifyPhoneSecondPage({Key? key}) : super(key: key);

  @override
  State<VerifyPhoneSecondPage> createState() => _VerifyPhoneSecondPageState();
}

class _VerifyPhoneSecondPageState extends State<VerifyPhoneSecondPage> {
  String _value = "";
  bool _loadingVerify = false;
  bool _loadingCall = false;

  void onCompleted(String value) {
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(), // Empty container to push the content to the center and bottom
          _Title(onCompleted: onCompleted),
          Column(
            children: [
              Button(
                loading: _loadingCall,
                type: ButtonType.outlined,
                child: Text(
                  l10n.callInstead,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    _loadingCall = true;
                  });
                  // Send a call verification request
                  await Api.v1.accounts.verification.phone.call((await AccountCache.getToken())!);
                  // Show a notification
                  SnackbarPresets.show(
                    context,
                    text: l10n.verificationCodeSent,
                  );

                  setState(() {
                    _loadingCall = false;
                  });
                }
              ),
              const SizedBox(height: 8,),
              Button(
                loading: _loadingVerify,
                disabled: _value.length != 6,
                child: Text(
                  l10n.verify,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    _loadingVerify = true;
                  });
                  // Check if the code is valid
                  bool result = await Api.v1.accounts.verification.phone.verify((await AccountCache.getToken())!, _value);

                  // If the code is valid, show a success notification and close the popup
                  if (result) {
                    SnackbarPresets.show(
                      context,
                      text: l10n.verificationSuccessful,
                    );
                    AccountResponseRequiredActions? requiredActions = await AccountCache.getRequiredActions();

                    if (requiredActions != null) {
                      await AccountCache.setRequiredActions(requiredActions.copyWith(verifyPhoneNumber: false));
                    }

                    OverlaySupportEntry.of(context)!.dismiss(); // Close the popup

                  } else {
                    // If the code is invalid, show an error notification
                    SnackbarPresets.error(
                      context,
                      l10n.invalidVerificationCode,
                    );
                  }

                  setState(() {
                    _loadingVerify = false;
                  });
                }
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + Sizing.horizontalPadding / 2)
            ],
          )
        ],
      )
    );
  }
}
