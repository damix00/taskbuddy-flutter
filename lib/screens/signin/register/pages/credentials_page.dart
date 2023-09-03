import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/appbar/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/input/scrollbar_scroll_view.dart';
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
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ScreenTitle(title: l10n.registerCredentialsTitle, description: l10n.registerCredentialsDesc)
              ],
            ),
          )
        ),
      )
    );
  }
}
