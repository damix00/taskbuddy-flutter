import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/state/providers/preferences.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/radio.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppearanceThemeSetting extends StatefulWidget {
  const AppearanceThemeSetting({Key? key}) : super(key: key);

  @override
  _AppearanceThemeSettingState createState() => _AppearanceThemeSettingState();
}

class _AppearanceThemeSettingState extends State<AppearanceThemeSetting> {
  int _selected = 0;

  void _onChanged(int value) {
    setState(() {
      _selected = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: Text(
          l10n.theme,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Consumer<PreferencesModel>(
          builder: (context, value, child) {
            _selected = value.themeMode == ThemeMode.system
                ? 0
                : value.themeMode == ThemeMode.light
                    ? 1
                    : 2;

            return RadioButtons(
              onChanged: (v) {
                switch (v) {
                  case 0:
                    value.setThemeMode(ThemeMode.system);
                    break;
                  case 1:
                    value.setThemeMode(ThemeMode.light);
                    break;
                  case 2:
                    value.setThemeMode(ThemeMode.dark);
                    break;
                }
              },
              selected: _selected,
              items: [
                RadioItem(title: l10n.system),
                RadioItem(title: l10n.light),
                RadioItem(title: l10n.dark),
              ]
            );
          },
          child: Container(),
        ),
      )
    );
  }
}
