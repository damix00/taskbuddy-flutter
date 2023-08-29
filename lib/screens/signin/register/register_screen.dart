import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taskbuddy/widgets/appbar/blur_appbar.dart';
import 'package:taskbuddy/widgets/input/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/input/touchable/button.dart';
import 'package:taskbuddy/widgets/input/touchable/checkbox.dart';
import 'package:taskbuddy/widgets/input/touchable/link_text.dart';
import 'package:taskbuddy/widgets/ui/gradient_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:styled_text/styled_text.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BlurAppbar.appBar(),
      body: ScrollbarSingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
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
              const _ScreenMiddle(),
              const _ScreenBottom(),
            ],),
          )
        )
      )
    );
  }
}

class _ScreenMiddle extends StatelessWidget {
  const _ScreenMiddle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _Title(),
        SizedBox(
          height: 16,
        ),
        _Description(),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GradientText(AppLocalizations.of(context)!.registerTitle,
          gradient: GradientText.getDefaultGradient(context)),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.registerDesc,
        textAlign: TextAlign.center,
      ),
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
            text: l10n.termsAndConditions("https://google.com"),
            tags: {
              'link': StyledTextActionTag((_, attrs) async {
                await launchUrl(Uri.parse(attrs['href']!),
                    mode: Platform.isAndroid
                        ? LaunchMode.inAppWebView
                        : LaunchMode.externalApplication);
                },
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
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
            onPressed: () {}),
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
