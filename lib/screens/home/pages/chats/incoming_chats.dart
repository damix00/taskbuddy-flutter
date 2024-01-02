import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/screens/home/pages/chats/channel_tile.dart';
import 'package:taskbuddy/state/providers/messages.dart';
import 'package:taskbuddy/widgets/ui/feedback/custom_refresh.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

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
        return CustomRefresh(
          paddingTop: MediaQuery.of(context).padding.top + 56,
          onRefresh: () async {
            model.hasMoreIncoming = true;
            model.incomingOffset = 0;
            model.incomingMessages = [];

            await model.fetchIncoming();
          },
          child: CustomScrollView(
            slivers: [
              SliverList.builder(
                itemCount: model.incomingMessages.length + (model.loadingIncoming ? 1 : 0),
                itemBuilder: (ctx, index) {
                  var padding = MediaQuery.of(ctx).padding;

                  if (index == model.incomingMessages.length) {
                    return Padding(
                      padding: EdgeInsets.only(
                        top: index == 0 ? padding.top + 64 : 0,
                        left: Sizing.horizontalPadding,
                        right: Sizing.horizontalPadding,
                        bottom: padding.bottom,
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  var channel = model.incomingMessages[index];
        
                  // Lazy load more incoming messagesq
                  if (index == model.incomingMessages.length - 1 && model.hasMoreIncoming && !model.loadingIncoming) {
                    model.fetchIncoming();
                  }
        
                  return Padding(
                    padding: EdgeInsets.only(
                      top: 16,
                      left: Sizing.horizontalPadding,
                      right: Sizing.horizontalPadding,
                      bottom: index == model.incomingMessages.length - 1 ? padding.bottom : 0,
                    ),
                    child: ChannelTile(
                      channel: channel,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
