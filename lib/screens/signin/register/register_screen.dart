import 'dart:math';

import 'package:flutter/material.dart';
import 'package:taskbuddy/state/static/register_state.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:taskbuddy/widgets/ui/platforms/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/checkbox.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/link_text.dart';
import 'package:taskbuddy/widgets/screens/register/screen_title.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:styled_text/styled_text.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:taskbuddy/widgets/ui/visual/markdown.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BlurAppbar.appBar(),
      body: ScrollbarSingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: max(MediaQuery.of(context).size.height, 500),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top * 2 + 16,
              ),
              ScreenTitle(title: l10n.registerTitle, description: l10n.registerDesc),
              const _ScreenBottom(),
            ],),
          )
        )
      )
    );
  }
}

class _ScreenBottom extends StatefulWidget {
  const _ScreenBottom({Key? key}) : super(key: key);

  @override
  State<_ScreenBottom> createState() => _ScreenBottomState();
}

class _ScreenBottomState extends State<_ScreenBottom> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        TBCheckbox(
          mainAxisAlignment: MainAxisAlignment.center,
          value: _agreed,
          onChanged: (v) {
            setState(() {
              _agreed = v;
            });
          },
          child: StyledText(
            text: l10n.termsAndConditionsAgree,
            tags: {
              'link': StyledTextActionTag((_, attrs) async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          l10n.termsAndConditions,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        content: ScrollbarSingleChildScrollView(
                          child: FutureBuilder(
                            future: DefaultAssetBundle.of(context).loadString('assets/terms.md'),
                            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                              if (snapshot.hasData) {
                                return Markdown(
                                  data: snapshot.data!,
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.w900,
                )
              )
            }
          )
        ),
        const SizedBox(
          height: 16,
        ),
        Button(
            disabled: !_agreed,
            child: Text(l10n.continueText,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
            onPressed: () {
              // Clear the previous registration state
              RegisterState.clear();

              // Show the next registration step
              // In the credentials, the user will define their email and password
              Navigator.pushNamed(context, '/register/creds');
            }),
        const SizedBox(
          height: 16,
        ),
        LinkText(
          text: l10n.alreadyHaveAccount,
          onTap: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
        SizedBox(
          height: MediaQuery.of(context).padding.bottom + 16,
        ),
      ],
    );
  }
}
