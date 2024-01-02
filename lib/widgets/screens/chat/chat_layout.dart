import 'package:flutter/material.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/account/public_account_response.dart';
import 'package:taskbuddy/api/responses/chats/channel_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/utils/dates.dart';
import 'package:taskbuddy/widgets/navigation/blur_parent.dart';
import 'package:taskbuddy/widgets/screens/chat/chat_bubble.dart';
import 'package:taskbuddy/widgets/screens/chat/chat_input.dart';
import 'package:taskbuddy/widgets/screens/chat/chat_post_info.dart';

class ChatLayout extends StatefulWidget {
  final ChannelResponse channel;

  const ChatLayout({
    Key? key,
    required this.channel
  }) : super(key: key);

  @override
  State<ChatLayout> createState() => _ChatLayoutState();
}

class _ChatLayoutState extends State<ChatLayout> {
  final TextEditingController _textController = TextEditingController();

  Future<void> _markAsSeen() async {
    PublicAccountResponse otherUser = widget.channel.otherUser == "recipient" ? widget.channel.channelRecipient : widget.channel.channelCreator;

    for (var message in widget.channel.lastMessages) {
      if (!message.seen && message.sender.UUID == otherUser.UUID) {
        message.seen = true;
      }
    }

    String token = (await AccountCache.getToken())!;
    // Mark as seen
    await Api.v1.channels.markAsSeen(token, widget.channel.uuid);
  }

  void _init() async {
    PublicAccountResponse otherUser = widget.channel.otherUser == "recipient" ? widget.channel.channelRecipient : widget.channel.channelCreator;

    if (
      widget.channel.lastMessages.isNotEmpty &&
      widget.channel.lastMessages[0].sender.UUID == otherUser.UUID &&
      !widget.channel.lastMessages[0].seen
    ) {
      _markAsSeen();
    }
  }

  @override
  void initState() {
    super.initState();

    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(height: MediaQuery.of(context).padding.top),
            ),
            SliverToBoxAdapter(
              child: ChatPostInfo(channel: widget.channel),
            ),

            // Chat messages
            SliverList.builder(
              itemCount: widget.channel.lastMessages.length,
              itemBuilder: (context, index) {
                bool showSeen = widget.channel.lastMessages[index].sender.isMe
                  && index == widget.channel.lastMessages.length - 1
                  && widget.channel.lastMessages[index].seen;

                bool showPfp = index == widget.channel.lastMessages.length - 1 ||
                  widget.channel.lastMessages[index + 1].sender.UUID != widget.channel.lastMessages[index].sender.UUID;

                // Show date header
                if (index == 0 || widget.channel.lastMessages[index].createdAt.day != widget.channel.lastMessages[index - 1].createdAt.day) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          Dates.formatDate(widget.channel.lastMessages[index].createdAt, showTime: false),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                      ChatBubble(
                        message: widget.channel.lastMessages[index],
                        showSeen: showSeen,
                        showProfilePicture: showPfp,
                      ),
                    ],
                  );
                }

                return ChatBubble(
                  message: widget.channel.lastMessages[index],
                  showSeen: showSeen,
                  showProfilePicture: showPfp,
                );
              },
            ),

            // Padding
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).padding.bottom + 44 + 12 + 16,
              )
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).padding.bottom + 44 + 12,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 12,
              left: 16,
              right: 16,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(32)),
              child: BlurParent(
                child: ChatInput(
                  controller: _textController,
                  onSend: (message) async {
                    if (message.isNotEmpty) {
                      _textController.clear();
                      FocusScope.of(context).unfocus();

                      String token = (await AccountCache.getToken())!;

                      // Send message
                      var result = await Api.v1.channels.messages.sendMessage(
                        token,
                        channelUUID: widget.channel.uuid,
                        message: message
                      );

                      if (result.ok) {
                        setState(() {
                          widget.channel.lastMessages.add(result.data!);
                        });

                        // Scroll to bottom
                        if (widget.channel.lastMessages.length > 0) {
                          await Future.delayed(Duration(milliseconds: 100));
                          Scrollable.ensureVisible(
                            context,
                            alignment: 1,
                            duration: Duration(milliseconds: 100),
                            curve: Curves.easeInOut,
                          );
                        }
                      }
                    }
                  },
                ),
              ),
            ),
          )
        ),
      ],
    );
  }
}
