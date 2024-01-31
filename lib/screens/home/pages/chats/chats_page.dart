import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/api/responses/chats/channel_response.dart';
import 'package:taskbuddy/api/responses/chats/message_response.dart';
import 'package:taskbuddy/api/socket/socket.dart';
import 'package:taskbuddy/screens/chat/chat_screen.dart';
import 'package:taskbuddy/screens/home/pages/chats/incoming_chats.dart';
import 'package:taskbuddy/screens/home/pages/chats/outgoing_chats.dart';
import 'package:taskbuddy/state/providers/messages.dart';
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

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  void _onMessage(dynamic data) {
    MessagesModel model = Provider.of<MessagesModel>(context, listen: false);
    MessageResponse response = MessageResponse.fromJson(data["message"]);

    log("Received message (main screen): ${response.message}");

    model.onMessage(response.channelUUID, response.clone());
    model.sortChannels();
  }

  void _onNewChannel(dynamic data) {
    MessagesModel model = Provider.of<MessagesModel>(context, listen: false);
    ChannelResponse response = ChannelResponse.fromJson(data["channel"]);

    model.addIncomingChannel(response.clone());
    model.sortChannels();
  }

  void _handleMessage(RemoteMessage message) {
    // Handle the message
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ChatScreen(
          channelUuid: message.data["channel_uuid"]!,
        )
      )
    );
  }

  void _onDeleted(dynamic data) {
    MessagesModel model = Provider.of<MessagesModel>(context, listen: false);

    model.deleteMessage(data["message_uuid"]!);
  }

  void _onChannelUpdate(dynamic data) {
    MessagesModel model = Provider.of<MessagesModel>(context, listen: false);
    ChannelResponse response = ChannelResponse.fromJson(data["channel"]);

    model.updateChannel(response.clone());
  }

  void _onSeen(dynamic data) {
    MessagesModel model = Provider.of<MessagesModel>(context, listen: false);

    model.setAsSeen(data["channel_uuid"]);
  }

  void _onMessageUpdated(dynamic data) {
    MessagesModel model = Provider.of<MessagesModel>(context, listen: false);
    MessageResponse response = MessageResponse.fromJson(data["message"]);

    model.updateMessage(response.clone());
  }

  @override
  void initState() {
    super.initState();

    SocketClient.addListener("chat", _onMessage);
    SocketClient.addListener("channel_seen", _onSeen);
    SocketClient.addListener("new_channel", _onNewChannel);
    SocketClient.addListener("message_deleted", _onDeleted);
    SocketClient.addListener("channel_update", _onChannelUpdate);
    SocketClient.addListener("message_updated", _onMessageUpdated);
  }

  @override
  void dispose() {
    SocketClient.disposeListener("chat", _onMessage);
    SocketClient.disposeListener("channel_seen", _onSeen);
    SocketClient.disposeListener("new_channel", _onNewChannel);
    SocketClient.disposeListener("message_deleted", _onDeleted);
    SocketClient.disposeListener("channel_update", _onChannelUpdate);
    SocketClient.disposeListener("message_updated", _onMessageUpdated);

    super.dispose();
  }

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
