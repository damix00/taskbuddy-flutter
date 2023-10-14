import 'package:flutter/material.dart';
import 'package:taskbuddy/screens/settings/items/navigation.dart';
import 'package:taskbuddy/screens/settings/section.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/ui/platforms/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: Text(
          AppLocalizations.of(context)!.settings,
          style: Theme.of(context).textTheme.titleSmall,
        )
      ),
      extendBodyBehindAppBar: true,
      body: ScrollbarSingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + Sizing.appbarHeight),
            SettingsSection(
              title: l10n.account,
              children: [
                SettingsNavigation(title: l10n.account, icon: Icons.person_outline, onTap: () {}),
                SettingsNavigation(title: l10n.privacy, icon: Icons.lock_outline, onTap: () {}),
              ]
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}