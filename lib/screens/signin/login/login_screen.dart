import 'dart:math';

import 'package:flutter/material.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/utils/validators.dart';
import 'package:taskbuddy/widgets/appbar/blur_appbar.dart';
import 'package:taskbuddy/widgets/input/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/input/text_input.dart';
import 'package:taskbuddy/widgets/input/touchable/button.dart';
import 'package:taskbuddy/widgets/input/touchable/link_text.dart';
import 'package:taskbuddy/widgets/screens/screen_title.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:taskbuddy/widgets/ui/snackbars.dart';

// Login screen widget
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BlurAppbar.appBar(), // AppBar with blur effect
      body: ScrollbarSingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: max(MediaQuery.of(context).size.height, 600), // Set minimum height to the screen height
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ScreenTitle(title: l10n.loginTitle, description: l10n.loginDesc,), // Display screen title and description
                const SizedBox(
                  height: Sizing.formSpacing,
                ),
                const _LoginForm(), // Display login form
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextInput(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            label: l10n.email,
            hint: 'latinary@example.com',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.emptyField(l10n.email);
              }
              if (!Validators.isEmailValid(value)) {
                return l10n.invalidEmail;
              }
              return null;
            },
          ),
          const SizedBox(
            height: Sizing.inputSpacing,
          ),
          TextInput(
            controller: _passwordController,
            label: l10n.password,
            hint: 'coolpassword123',
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.emptyField(l10n.password);
              }

              // Client-side validation for the password is not necessary
              // as the requirements can change on the server-side.
              return null;
            },
          ),
          const SizedBox(height: Sizing.formSpacing),
          Button(
              loading: loading,
              child: Text(
                l10n.loginBtn,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    loading = true;
                  });
                  final response = await Api.v1.accounts
                      .login(_emailController.text, _passwordController.text);

                  if (!response.ok) {
                    var _errorText = l10n.internalServerError;
                    if (response.status == 408) {
                      _errorText = l10n.requestTimedOut;
                    } else if (!response.ok) {
                      _errorText = l10n.invalidCredentials;
                    }

                    SnackbarPresets.show(context, _errorText);
                  }

                  setState(() {
                    loading = false;

                    if (response.ok) {
                      // Show the home screen
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (route) => false);
                    }
                  });
                }
              }),
          const SizedBox(
            height: 12,
          ),
          LinkText(text: l10n.forgotPassword, onTap: () {}),
          const SizedBox(
            height: 6,
          ),
          LinkText(text: l10n.dontHaveAccount, onTap: () {
            Navigator.pushReplacementNamed(context, '/register');
          }),
        ],
      ),
    );
  }
}
