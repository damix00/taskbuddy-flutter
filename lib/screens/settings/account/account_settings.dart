import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/socket/socket.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/screens/settings/items/button.dart';
import 'package:taskbuddy/screens/settings/items/navigation.dart';
import 'package:taskbuddy/screens/settings/section.dart';
import 'package:taskbuddy/state/providers/auth.dart';
import 'package:taskbuddy/state/providers/messages.dart';
import 'package:taskbuddy/utils/utils.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/overlays/dialog/dialog.dart';
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
            onTap: () {
              // Open dialog that shows email
              CustomDialog.show(
                context,
                title: l10n.email,
                description: value.email,
                actions: [
                  DialogAction(
                    text: "OK",
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ]
              );
            },
            value: value.email,
          ),
          SettingsNavigation(
            onTap: () {
              // Open change password screen
              Navigator.of(context).pushNamed("/settings/account/change-password");
            },
            icon: Icons.password_outlined,
            title: l10n.changePassword
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
                  String token = (await AccountCache.getToken())!;

                  await Api.v1.accounts.meRoute.logout(token);

                  await Provider.of<AuthModel>(context, listen: false).logout();
                  Provider.of<MessagesModel>(context, listen: false).clear();

                  // Disconnect from socket
                  SocketClient.disconnect();
        
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
