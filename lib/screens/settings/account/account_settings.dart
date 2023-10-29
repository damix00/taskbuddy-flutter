import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/screens/settings/items/button.dart';
import 'package:taskbuddy/screens/settings/items/item.dart';
import 'package:taskbuddy/screens/settings/items/navigation.dart';
import 'package:taskbuddy/screens/settings/section.dart';
import 'package:taskbuddy/state/providers/auth.dart';
import 'package:taskbuddy/utils/utils.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/ui/platforms/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class _AccountInfo extends StatelessWidget {
  const _AccountInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Consumer<AuthModel>(
      builder: (context, value, child) => SettingsSection(
        title: l10n.accountInformation,
        children: [
          SettingsNavigation(
            title: l10n.email,
            icon: Icons.email_outlined,
            onTap: () {},
            value: value.email,
          )
        ]
      )
    );
  }
}

class AccountSettings extends StatelessWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BlurAppbar.appBar(
        child: Text(
          AppLocalizations.of(context)!.account,
          style: Theme.of(context).textTheme.titleSmall,
        )
      ),
      body: ScrollbarSingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + Sizing.appbarHeight),
              const _AccountInfo(),
              const SizedBox(height: 16,),
              SettingsButton(
                icon: Icons.logout_outlined,
                iconColor: Theme.of(context).colorScheme.error,
                child: Text(
                  l10n.logout,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                onTap: () async {
                  await AccountCache.setLoggedIn(false);
                  await AccountCache.clear();
        
                  Utils.restartLoggedOut(context);
                }
              )
            ],
          ),
        ),
      )
    );
  }
}
