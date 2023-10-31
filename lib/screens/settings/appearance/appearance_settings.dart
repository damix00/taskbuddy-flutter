import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/screens/settings/items/check.dart';
import 'package:taskbuddy/screens/settings/items/navigation.dart';
import 'package:taskbuddy/screens/settings/section.dart';
import 'package:taskbuddy/state/providers/preferences.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/ui/platforms/scrollbar_scroll_view.dart';

class AppearanceSettings extends StatelessWidget {
  const AppearanceSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: Text(
          AppLocalizations.of(context)!.appearanceAndAccessibility,
          style: Theme.of(context).textTheme.titleSmall,
        ) 
      ),
      extendBodyBehindAppBar: true,
      body: ScrollbarSingleChildScrollView(
        child: Consumer<PreferencesModel>(
          builder: (context, value, child) {
            return Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                SettingsSection(
                  title: l10n.appearance,
                  children: [
                    SettingsNavigation(
                      title: l10n.theme,
                      icon: Icons.color_lens_outlined,
                      value: value.themeMode == ThemeMode.system
                          ? l10n.system
                          : value.themeMode == ThemeMode.light
                              ? l10n.light
                              : l10n.dark,
                      onTap: () {
                        Navigator.of(context).pushNamed('/settings/appearance/theme');
                      }
                    )
                  ]
                ),
                SettingsSection(
                  title: l10n.advanced,
                  children: [
                    SettingsCheck(
                      title: l10n.uiBlur,
                      subtitle: l10n.uiBlurDesc,
                      icon: Icons.blur_on_outlined,
                      value: value.uiBlurEnabled,
                      onChanged: (v) {
                        value.setUiBlurEnabled(v);
                      }
                    )
                  ]
                ),
              ],
            );
          },
        ),
      )
    );
  }
}