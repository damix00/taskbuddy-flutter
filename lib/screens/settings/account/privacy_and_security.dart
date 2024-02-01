import 'package:flutter/material.dart';
import 'package:taskbuddy/screens/settings/items/button.dart';
import 'package:taskbuddy/screens/settings/items/navigation.dart';
import 'package:taskbuddy/screens/settings/section.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/ui/platforms/scrollbar_scroll_view.dart';

class PrivacyAndSecurityScreen extends StatelessWidget {
  const PrivacyAndSecurityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: AppbarTitle(
          l10n.privacyAndSecurity
        )
      ),
      extendBodyBehindAppBar: true,
      body: const _PageContent()
    );
  }
}

class _PageContent extends StatelessWidget {
  const _PageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return ScrollbarSingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          SettingsSection(
            title: l10n.security,
            children: [
              SettingsNavigation(
                title: l10n.loginSessions,
                icon: Icons.key_outlined,
                onTap: () {
                  Navigator.of(context).pushNamed('/settings/account/login-sessions');
                }
              ),
              SettingsButton(
                icon: Icons.logout,
                iconColor: Theme.of(context).colorScheme.error,
                onTap: () {},
                child: Text(
                  l10n.logOutEverywhere,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error
                  ),
                ),
              )
            ],
          ),
          SettingsSection(
            title: l10n.privacy,
            children: [
              SettingsButton(
                icon: Icons.delete_outline,
                iconColor: Theme.of(context).colorScheme.error,
                onTap: () {},
                child: Text(
                  l10n.deleteAccount,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
