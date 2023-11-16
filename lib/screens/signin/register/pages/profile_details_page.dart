import 'dart:math';

import 'package:flutter/material.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/state/static/register_state.dart';
import 'package:taskbuddy/utils/validators.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/ui/platforms/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/input/with_state/text_input.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/screens/register/screen_title.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:taskbuddy/widgets/ui/feedback/snackbars.dart';
import 'package:taskbuddy/widgets/ui/visual/disclaimer_text.dart';

class ProfileDetailsPage extends StatelessWidget {
  const ProfileDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: BlurAppbar.appBar(
            child: Text(
          AppLocalizations.of(context)!.registerDetailsAppbar,
          style: Theme.of(context).textTheme.titleSmall,
        )),
        body: ScrollbarSingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizing.horizontalPadding,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: max(MediaQuery.of(context).size.height, 800),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ScreenTitle(
                      title: AppLocalizations.of(context)!.registerDetailsTitle,
                      description:
                          AppLocalizations.of(context)!.registerDetailsDesc),
                  const SizedBox(height: Sizing.formSpacing),
                  const _DetailsForm(),
                ],
              ),
            ),
          ),
        ));
  }
}

class _DetailsForm extends StatefulWidget {
  const _DetailsForm({Key? key}) : super(key: key);

  @override
  __DetailsFormState createState() => __DetailsFormState();
}

class __DetailsFormState extends State<_DetailsForm> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for the text inputs
  final TextEditingController _firstNameController = TextEditingController(text: RegisterState.firstName);
  final TextEditingController _lastNameController = TextEditingController(text: RegisterState.lastName);
  final TextEditingController _usernameController = TextEditingController(text: RegisterState.username);

  bool _usernameTaken = false;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                // First name
                child: TextInput(
                  controller: _firstNameController,
                  label: l10n.firstName,
                  hint: 'Mathew',
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return l10n.emptyField(l10n.firstName);
                    }
                    return null;
                  }
                )
              ),
              const SizedBox(width: Sizing.inputSpacing,),
              Flexible(
                // Last name
                child: TextInput(
                  controller: _lastNameController,
                  label: l10n.lastName,
                  hint: 'Pizey',
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return l10n.emptyField(l10n.lastName);
                    }
                    return null;
                  }
                )
              ),
            ],
          ),
          const SizedBox(height: Sizing.inputSpacing,),
          TextInput(
            errorText: _usernameTaken ? l10n.usernameTaken : null,
            controller: _usernameController,
            tooltipText: l10n.usernameTooltip,
            label: l10n.username,
            hint: 'its.mr_p123',
            keyboardType: TextInputType.text,
            validator: (v) {
              if (v == null || v.isEmpty) {
                return l10n.emptyField(l10n.username);
              }

              return Validators.validateUsername(context, v);
            }
          ),
          const SizedBox(height: Sizing.formSpacing,),
          Button(
            loading: _loading,
            child: Text(
              l10n.continueText,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)
            ),
            onPressed: () async {
              // If there are no input errors, continue
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _loading = true;
                  _usernameTaken = false;
                });

                var exists = await Api.v1.accounts.checkExistence.username(_usernameController.text, fakeDelay: const Duration(milliseconds: 400));

                if (exists.error != null) {
                  setState(() {
                    _loading = false;
                  });
                  SnackbarPresets.networkError(context);
                } else {
                  setState(() {
                  _usernameTaken = exists.username!;
                    _loading = false;
                  });

                  if (!exists.username!) {
                    // Save the data to the register state
                    RegisterState.firstName = _firstNameController.text;
                    RegisterState.lastName = _lastNameController.text;
                    RegisterState.username = _usernameController.text;

                    // Navigate to the final registration step
                    Navigator.pushNamed(context, '/register/profile/finish');
                  }
                }
              }
            }
          ),
          const SizedBox(height: Sizing.inputSpacing,),
          DisclaimerText(text: l10n.profileDisclaimer),
        ],
      ),
    );
  }
}
