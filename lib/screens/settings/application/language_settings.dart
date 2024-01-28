import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/state/providers/preferences.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/radio.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';

class LanguageSettings extends StatelessWidget {
  const LanguageSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: BlurAppbar.appBar(
        child: Text(
          l10n.language,
          style: Theme.of(context).textTheme.titleSmall,
        )
      ),
      body: Consumer<PreferencesModel>(
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: AppLocalizations.supportedLocales.length + 1,
            itemBuilder: (context, index) {
              int _current = -1;

              if (value.preferredLanguage != "") {
                _current = AppLocalizations.supportedLocales.indexWhere((element) => element.languageCode == value.preferredLanguage);
              }

              if (index == 0) {
                return RadioButtonItem(
                  onChanged: (v) {
                    value.setPreferredLanguage("");
                  },
                  selected: _current == -1 ? 0 : _current + 1,
                  item: RadioItem(
                    title: l10n.deviceDefault
                  ),
                  index: index
                );
              }

              return RadioButtonItem(
                onChanged: (v) {
                  value.setPreferredLanguage(AppLocalizations.supportedLocales[index - 1].languageCode);
                },
                selected: _current == -1 ? 0 : _current + 1,
                item: RadioItem(
                  title: AppLocalizations.supportedLocales[index - 1].languageCode.toUpperCase(),
                ),
                index: index
              );
            },
          );
        }
      )
    );
  }
}