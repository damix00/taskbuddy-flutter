import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/state/static/forgot_password_state.dart';
import 'package:taskbuddy/utils/initializers.dart';
import 'package:taskbuddy/utils/utils.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/with_state/text_inputs/text_input.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:taskbuddy/widgets/ui/feedback/snackbars.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: AppbarTitle(l10n.resetPassword)
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
  String _password = "";
  String _confirmPassword = "";
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Form(
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
              const SizedBox(height: Sizing.formSpacing),
              Center(
                child: Text(
                  l10n.resetPassword,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12,),
              Center(
                child: Text(
                  l10n.resetPasswordDesc,
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: Sizing.formSpacing),
              TextInput(
                hint: "e.g. **********",
                label: l10n.password,
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.emptyField(l10n.password);
                  }

                  if (value.length < 8) {
                    return l10n.passwordTooShort(8);
                  }
                  
                  return null;
                }
              ),
              const SizedBox(height: Sizing.inputSpacing),
              TextInput(
                hint: "e.g. **********",
                label: l10n.confirmPassword,
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    _confirmPassword = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.emptyField(l10n.password);
                  }

                  if (value.length < 8) {
                    return l10n.passwordTooShort(8);
                  }

                  return null;
                }
              ),
              const SizedBox(height: Sizing.formSpacing),
              Button(
                loading: _loading,
                child: ButtonText(l10n.resetPassword),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_password != _confirmPassword) {
                      SnackbarPresets.error(
                        context,
                        l10n.passwordsDontMatch
                      );
                      return;
                    }

                    setState(() {
                      _loading = true;
                    });

                    var data = await Api.v1.accounts.meRoute.security.forgotPassword.resetPassword(
                      ForgotPasswordState.email,
                      ForgotPasswordState.otp,
                      _password
                    );

                    setState(() {
                      _loading = false;
                    });

                    if (data.status == 403) {
                      SnackbarPresets.error(
                        context,
                        l10n.invalidCode
                      );
                      return;
                    }

                    else if (!data.ok) {
                      SnackbarPresets.error(
                        context,
                        l10n.somethingWentWrong
                      );
                      return;
                    }

                    SnackbarPresets.show(
                      context,
                      text: l10n.successfullyChanged
                    );

                    // Save the data
                    await AccountCache.saveAccountResponse(data.data!);
                    await AccountCache.saveProfile(data.data!.profile!);

                    await Initializers.initCache(context);

                    // Restart the app
                    Utils.restartLoggedIn(context);
                  }
                },
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ]
          ),
        )
      )
    );
  }
}
