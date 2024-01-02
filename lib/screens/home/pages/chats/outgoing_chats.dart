import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/screens/home/pages/chats/channel_tile.dart';
import 'package:taskbuddy/state/providers/messages.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class OutgoingChats extends StatefulWidget {
  const OutgoingChats({Key? key}) : super(key: key);

  @override
  State<OutgoingChats> createState() => _OutgoingChatsState();
}

class _OutgoingChatsState extends State<OutgoingChats> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MessagesModel>(
      builder: (ctx, model, child) {
        return ListView.builder(
          itemCount: model.outgoingMessages.length,
          itemBuilder: (ctx, index) {
            var channel = model.outgoingMessages[index];
            var padding = MediaQuery.of(ctx).padding;

            // Lazy load more incoming messagesq
            if (index == model.outgoingMessages.length - 1 && model.hasMoreOutgoing && !model.loadingOutgoing) {
              model.fetchOutgoing();
            }

            return Padding(
              padding: EdgeInsets.only(
                top: index == 0 ? padding.top + 64 : 0,
                left: Sizing.horizontalPadding,
                right: Sizing.horizontalPadding,
                bottom: index == model.outgoingMessages.length - 1 ? padding.bottom : 0,
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
