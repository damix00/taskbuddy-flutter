import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/state/static/forgot_password_state.dart';
import 'package:taskbuddy/utils/validators.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/with_state/text_inputs/text_input.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:taskbuddy/widgets/ui/feedback/snackbars.dart';
import 'package:taskbuddy/widgets/ui/platforms/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: AppbarTitle(l10n.forgotPassword)
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
  String _email = "";
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return ScrollbarSingleChildScrollView(
      child: Form(
        key: _formKey,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                Center(
                  child: Text(
                    l10n.forgotPassword,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.forgotPasswordDesc,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium
                ),
                const SizedBox(height: Sizing.formSpacing),
                TextInput(
                  label: l10n.email,
                  hint: "latinary@example.com",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.emptyField(l10n.email);
                    }
                    if (!Validators.isEmailValid(value)) {
                      return l10n.invalidEmail;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _email = value;
                  },
                ),
                const SizedBox(height: Sizing.formSpacing),
                Button(
                  loading: _loading,
                  child: ButtonText(l10n.sendCode),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _loading = true;
                      });

                      bool success = await Api.v1.accounts.meRoute.security.forgotPassword.sendCode(_email);

                      setState(() {
                        _loading = false;
                      });

                      if (!success) {
                        SnackbarPresets.show(
                          context,
                          text: l10n.somethingWentWrong
                        );
                        return;
                      }
                      
                      SnackbarPresets.show(
                        context,
                        text: l10n.codeSent
                      );

                      ForgotPasswordState.email = _email;

                      Navigator.of(context).pushNamed(
                        "/forgot-password/enter-code",
                        arguments: _email
                      );
                    }
                  },
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
