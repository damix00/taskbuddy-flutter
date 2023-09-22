import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:taskbuddy/widgets/appbar/blur_appbar.dart';
import 'package:taskbuddy/widgets/input/pfp_input.dart';
import 'package:taskbuddy/widgets/input/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/input/text_input.dart';
import 'package:taskbuddy/widgets/input/touchable/button.dart';
import 'package:taskbuddy/widgets/screens/register/screen_title.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class ProfileFinishPage extends StatelessWidget {
  const ProfileFinishPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BlurAppbar.appBar(
        child: Text(
          l10n.finalRegisterAppbar,
          style: Theme.of(context).textTheme.titleSmall,
        )
      ),
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
                  title: l10n.finalRegisterTitle,
                  description: l10n.finalRegisterDesc,
                ),
                const SizedBox(height: Sizing.formSpacing),
                const _OptionalForm(),
              ],
            ),
          ),
        ),
      )
    );
  }
}

class _OptionalForm extends StatefulWidget {
  const _OptionalForm({Key? key}) : super(key: key);

  @override
  __OptionalFormState createState() => __OptionalFormState();
}

class __OptionalFormState extends State<_OptionalForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          ProfilePictureInput(
            onSelected: (file) {
              
            },
          ),
          // Biograpy text field
          TextInput(
            optional: true,
            label: l10n.biography,
            hint: l10n.bioPlaceholder,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            maxLength: 150,
            minLines: 3,
            maxLines: null,
          ),
          const SizedBox(height: Sizing.formSpacing,),
          Button(
            child: Text(
              AppLocalizations.of(context)!.signUpBtnFinish,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            onPressed: () {
              _formKey.currentState?.validate();
            },
          ),
        ],
      ),
    );
  }
}
