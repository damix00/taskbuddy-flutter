import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/screens/home/pages/chats/channel_tile.dart';
import 'package:taskbuddy/state/providers/messages.dart';

class IncomingChats extends StatefulWidget {
  const IncomingChats({Key? key}) : super(key: key);

  @override
  State<IncomingChats> createState() => _IncomingChatsState();
}

class _IncomingChatsState extends State<IncomingChats> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MessagesModel>(
      builder: (ctx, model, child) {
        return ListView.builder(
          itemCount: model.incomingMessages.length,
          itemBuilder: (ctx, index) {
            var channel = model.incomingMessages[index];
            var padding = MediaQuery.of(ctx).padding;

            return Padding(
              padding: EdgeInsets.only(
                top: index == 0 ? padding.top + 64 : 0,
                left: 12,
                right: 12,
                bottom: index == model.incomingMessages.length - 1 ? padding.bottom: 0,
              ),
              child: ChannelTile(
                channel: channel,
              ),
            );
          },
        );
      },
    );
  }
}