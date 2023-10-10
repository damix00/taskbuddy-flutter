import 'package:flutter/material.dart';
import 'package:taskbuddy/screens/settings/item.dart';
import 'package:taskbuddy/screens/settings/section.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/ui/platforms/scrollbar_scroll_view.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: Text(
          AppLocalizations.of(context)!.settings,
          style: Theme.of(context).textTheme.titleSmall,
        )
      ),
      body: ScrollbarSingleChildScrollView(
        child: Column(
          children: [
            SettingsSection(
              title: 'General',
              children: [
                SettingsNavigation(title: 'Account', subtitle: 'test test 123', icon: Icons.person, onTap: () {})
              ]
            )
          ],
        ),
      )
    );
  }
}