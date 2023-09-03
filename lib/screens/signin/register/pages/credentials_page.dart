import 'dart:math';

import 'package:flutter/material.dart';
import 'package:taskbuddy/state/static/register_state.dart';
import 'package:taskbuddy/utils/validators.dart';
import 'package:taskbuddy/widgets/appbar/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/input/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/input/text_input.dart';
import 'package:taskbuddy/widgets/input/touchable/button.dart';
import 'package:taskbuddy/widgets/screens/screen_title.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class CredentialsPage extends StatelessWidget {
  const CredentialsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BlurAppbar.appBar(
        child: Text(
          l10n.registerCredentialsAppbar,
          style: Theme.of(context).textTheme.titleSmall,
        )
      ),
      body: ScrollbarSingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding,),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: max(MediaQuery.of(context).size.height, 600),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ScreenTitle(title: l10n.registerCredentialsTitle, description: l10n.registerCredentialsDesc),
                const SizedBox(height: Sizing.formSpacing),
                const _CredentialsForm(),
              ],
            ),
          )
        ),
      )
    );
  }
}

class _CredentialsForm extends StatefulWidget {
  const _CredentialsForm({Key? key}) : super(key: key);

  @override
  __CredentialsFormState createState() => __CredentialsFormState();
}

class __CredentialsFormState extends State<_CredentialsForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _passwordValue = '';
  String _confirmPasswordValue = '';
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextInput(
            controller: _emailController,
            label: l10n.email,
            hint: 'example@latinary.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.emptyField(l10n.email);
              }
              if (!Validators.isEmailValid(value)) {
                return l10n.invalidEmail;
              }
              return null;
            }
          ),
          const SizedBox(height: Sizing.inputSpacing),
          TextInput(
            controller: _passwordController,
            label: l10n.password,
            hint: 'supersecretpassword',
            textInputAction: TextInputAction.next,
            obscureText: true,
            onChanged: (value) {
              _passwordValue = value;
            },
            validator: (value) {
              if (_confirmPasswordValue != value) {
                return l10n.passwordsDontMatch;
              }

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
            label: l10n.confirmPassword,
            hint: 'supersecretpassword',
            textInputAction: TextInputAction.done,
            obscureText: true,
            onChanged: (value) {
              _confirmPasswordValue = value;
            },
            validator: (value) {
              if (_passwordValue != value) {
                return l10n.passwordsDontMatch;
              }

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
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _loading = true;
                });

                RegisterState.email = _emailController.text;
                RegisterState.password = _passwordController.text;

                setState(() {
                  _loading = false;
                });
              }
            },
            child: Text(
              l10n.continueText,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)
            ),
          ),
        ],
      ),
    );
  }
}
