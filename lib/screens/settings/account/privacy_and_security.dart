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
import 'package:taskbuddy/widgets/overlays/loading_overlay.dart';
import 'package:taskbuddy/widgets/ui/feedback/snackbars.dart';
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
                onTap: () async {
                  // Show confirmation dialog
                  CustomDialog.show(
                    context,
                    title: l10n.logOutEverywhere,
                    description: l10n.logOutEverywhereConfirmation,
                    actions: [
                      DialogAction(
                        text: l10n.cancel,
                        onPressed: () {
                          Navigator.of(context).pop();
                        }
                      ),
                      DialogAction(
                        text: l10n.logout,
                        onPressed: () async {
                          Navigator.of(context).pop();
                          LoadingOverlay.showLoader(context);

                          String token = (await AccountCache.getToken())!;

                          var res = await Api.v1.accounts.meRoute.security.sessions.logoutAll(token);

                          LoadingOverlay.hideLoader(context);

                          if (!res) {
                            SnackbarPresets.error(
                              context,
                              l10n.somethingWentWrong
                            );
                          }

                          await Provider.of<AuthModel>(context, listen: false).logout();
                          Provider.of<MessagesModel>(context, listen: false).clear();

                          // Disconnect from socket
                          SocketClient.disconnect();
                
                          Utils.restartLoggedOut(context);
                        }
                      )
                    ]
                  );
                },
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
                onTap: () async {
                    CustomDialog.show(
                      context,
                      title: l10n.deleteAccount,
                      description: l10n.deleteAccountConfirmation,
                      actions: [
                        DialogAction(
                          text: l10n.cancel,
                          onPressed: () {
                            Navigator.of(context).pop();
                          }
                        ),
                        DialogAction(
                          text: l10n.deleteText,
                          onPressed: () async {
                            Navigator.of(context).pop();
                            LoadingOverlay.showLoader(context);
  
                            String token = (await AccountCache.getToken())!;
  
                            var res = await Api.v1.accounts.meRoute.security.deleteAccount(token);
  
                            LoadingOverlay.hideLoader(context);
  
                            if (!res) {
                              SnackbarPresets.error(
                                context,
                                l10n.somethingWentWrong
                              );

                              return;
                            }
  
                            await Provider.of<AuthModel>(context, listen: false).logout();
                            Provider.of<MessagesModel>(context, listen: false).clear();
  
                            // Disconnect from socket
                            SocketClient.disconnect();
                  
                            Utils.restartLoggedOut(context);
                          }
                        )
                      ]
                    );
                },
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
