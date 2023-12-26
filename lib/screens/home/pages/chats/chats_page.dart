import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/screens/home/pages/chats/incoming_chats.dart';
import 'package:taskbuddy/screens/home/pages/chats/outgoing_chats.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:taskbuddy/widgets/navigation/blur_parent.dart';

class ChatsAppbar extends StatelessWidget {
  const ChatsAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppbarTitle(l10n.chats)
      ],
    );
  }
}

class ChatsPage extends StatelessWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const TabBarView(
              children: [
                OutgoingChats(),
                IncomingChats()
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: BlurParent(
              child: TabBar(
                tabs: [
                  Tab(text: l10n.outgoing),
                  Tab(text: l10n.incoming)
                ]
              ),
            ),
          ),
        ],
      ),
    );
  }
}
