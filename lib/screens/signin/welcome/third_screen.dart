import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/screens/signin/welcome/welcome_screen_item.dart';

class WelcomeThirdScreen extends StatelessWidget {
  const WelcomeThirdScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WelcomeScreenItem(
      title: AppLocalizations.of(context)!.welcome__s3_title,
      description: AppLocalizations.of(context)!.welcome__s3_desc,
      image: 'assets/img/money.png',
    );
  }
}
