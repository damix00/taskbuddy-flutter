import 'package:flutter/material.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/with_state/text_inputs/text_input.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/ui/feedback/snackbars.dart';
import 'package:taskbuddy/widgets/ui/platforms/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: AppbarTitle(l10n.changePassword)
      ),
      extendBodyBehindAppBar: true,
      body: const _ChangePasswordForm()
    );
  }
}

class _ChangePasswordForm extends StatefulWidget {
  const _ChangePasswordForm({Key? key}) : super(key: key);

  @override
  __ChangePasswordFormState createState() => __ChangePasswordFormState();
}

class __ChangePasswordFormState extends State<_ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String _currentPassword = "";
  String _newPassword = "";
  String _confirmNewPassword = "";

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top + Sizing.horizontalPadding),
                    TextInput(
                      obscureText: true,
                      hint: "*********",
                      label: l10n.currentPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.emptyField(l10n.currentPassword);
                        }

                        if (value.length < 8) {
                          return l10n.passwordTooShort(8);
                        }

                        return null;
                      },
                      onChanged: (value) {
                        _currentPassword = value;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: Sizing.inputSpacing),
                    TextInput(
                      obscureText: true,
                      hint: "*********",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.emptyField(l10n.newPassword);
                        }

                        if (value.length < 8) {
                          return l10n.passwordTooShort(8);
                        }
                        
                        return null;
                      },
                      onChanged: (value) {
                        _newPassword = value;
                      },
                      label: l10n.newPassword,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: Sizing.inputSpacing),
                    TextInput(
                      obscureText: true,
                      hint: "*********",
                      label: l10n.confirmNewPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.emptyField(l10n.confirmNewPassword);
                        }

                        if (value.length < 8) {
                          return l10n.passwordTooShort(8);
                        }

                        return null;
                      },
                      onChanged: (value) {
                        _confirmNewPassword = value;
                      },
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: Sizing.formSpacing),
                  ],
                ),
          
                Column(
                  children: [
                    Button(
                      loading: _loading,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_newPassword != _confirmNewPassword) {
                            SnackbarPresets.error(
                              context,
                              l10n.passwordsDontMatch
                            );

                            return;
                          }

                          if (_currentPassword == _newPassword) {
                            SnackbarPresets.error(
                              context,
                              l10n.passwordsAreTheSame
                            );

                            return;
                          }

                          setState(() {
                            _loading = true;
                          });

                          String token = (await AccountCache.getToken())!;

                          var res = await Api.v1.accounts.meRoute.security.changePassword(
                            token,
                            _currentPassword,
                            _newPassword
                          );

                          setState(() {
                            _loading = false;
                          });

                          if (!res) {
                            SnackbarPresets.error(
                              context,
                              l10n.somethingWentWrong
                            );

                            return;
                          }

                          SnackbarPresets.show(
                            context,
                            text: l10n.success
                          );

                          Navigator.of(context).pop();
                        }
                      },
                      child: ButtonText(l10n.changePassword),
                    ),
                    SizedBox(height: MediaQuery.of(context).padding.bottom + Sizing.horizontalPadding),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
