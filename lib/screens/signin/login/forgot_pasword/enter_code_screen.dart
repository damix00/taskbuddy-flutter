import 'package:flutter/material.dart';
import 'package:taskbuddy/state/static/forgot_password_state.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/with_state/text_inputs/otp_input.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/ui/platforms/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class EnterCodeScreen extends StatelessWidget {
  const EnterCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: AppbarTitle(l10n.enterCode)
      ),
      extendBodyBehindAppBar: true,
      body: const _PageContent()
    );
  }
}

class _PageContent extends StatefulWidget {
  const _PageContent({Key? key}) : super(key: key);

  @override
  State<_PageContent> createState() => _PageContentState();
}

class _PageContentState extends State<_PageContent> {
  String _otp = "";
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return ScrollbarSingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizing.horizontalPadding,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              const SizedBox(height: Sizing.formSpacing),
              Text(
                l10n.enterCode,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 8,),
              Text(
                l10n.enterCodeDesc,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: Sizing.inputSpacing),
              OTPInput(
                onCompleted: (String value) {
                  setState(() {
                    _otp = value;
                  });
                },
              ),
              const SizedBox(height: Sizing.formSpacing),
              Button(
                onPressed: () async {
                  if (_otp.isEmpty) return;

                  setState(() {
                    _loading = true;
                  });

                  await Future.delayed(const Duration(seconds: 1));

                  ForgotPasswordState.otp = _otp;

                  setState(() {
                    _loading = false;
                  });

                  Navigator.pushNamed(context, "/forgot-password/reset");
                },
                loading: _loading,
                child: ButtonText(l10n.verify),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}
