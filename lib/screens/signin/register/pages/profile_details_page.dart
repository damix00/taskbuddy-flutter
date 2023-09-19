import 'dart:math';

import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/appbar/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/input/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/input/text_input.dart';
import 'package:taskbuddy/widgets/input/touchable/button.dart';
import 'package:taskbuddy/widgets/screens/screen_title.dart';
import 'package:taskbuddy/widgets/ui/disclaimer_text.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

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
                child: TextInput(
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
                child: TextInput(
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
            tooltipText: "Gay sex",
            label: l10n.username,
            hint: 'its.mr_p123',
            keyboardType: TextInputType.text,
            validator: (v) {}
          ),
          const SizedBox(height: Sizing.formSpacing,),
          Button(
            child: Text(
              l10n.continueText,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)
            ),
            onPressed: () {
              _formKey.currentState!.validate();
            }
          ),
          const SizedBox(height: Sizing.inputSpacing,),
          DisclaimerText(text: 'This is a disclaimer text.')
        ],
      ),
    );
  }
}
