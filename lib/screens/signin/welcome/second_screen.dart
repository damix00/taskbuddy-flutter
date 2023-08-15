import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/screens/signin/welcome/welcome_screen_item.dart';

class WelcomeSecondScreen extends StatelessWidget {
  const WelcomeSecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WelcomeScreenItem(
      title: AppLocalizations.of(context)!.welcome__s2_title,
      description: AppLocalizations.of(context)!.welcome__s2_desc,
      image: 'assets/img/clean.png',
    );
  }
}
