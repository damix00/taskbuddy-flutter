import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/screens/home/pages/chats/channel_tile.dart';
import 'package:taskbuddy/state/providers/messages.dart';
import 'package:taskbuddy/widgets/ui/feedback/custom_refresh.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class OutgoingChats extends StatefulWidget {
  const OutgoingChats({Key? key}) : super(key: key);

  @override
  State<OutgoingChats> createState() => _OutgoingChatsState();
}

class _OutgoingChatsState extends State<OutgoingChats> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<MessagesModel>(
      builder: (ctx, model, child) {
        return CustomRefresh(
          paddingTop: MediaQuery.of(context).padding.top + 56,
          onRefresh: () async {
            model.hasMoreOutgoing = true;
            model.outgoingOffset = 0;
            model.outgoingMessages = [];

            await model.fetchOutgoing();
          },
          child: CustomScrollView(
            slivers: [
              SliverList.builder(
                itemCount: model.outgoingMessages.length + (model.loadingOutgoing ? 1 : 0),
                itemBuilder: (ctx, index) {
                  var padding = MediaQuery.of(ctx).padding;

                  if (index == model.outgoingMessages.length) {
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

                  var channel = model.outgoingMessages[index];
        
                  // Lazy load more incoming messagesq
                  if (index == model.outgoingMessages.length - 1 && model.hasMoreOutgoing && !model.loadingOutgoing) {
                    model.fetchOutgoing();
                  }
        
                  return Padding(
                    padding: EdgeInsets.only(
                      top: 16,
                      left: Sizing.horizontalPadding,
                      right: Sizing.horizontalPadding,
                      bottom: index == model.outgoingMessages.length - 1 ? padding.bottom : 0,
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
