import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/account/public_account_response.dart';
import 'package:taskbuddy/api/responses/chats/channel_response.dart';
import 'package:taskbuddy/api/responses/chats/message_response.dart';
import 'package:taskbuddy/api/socket/socket.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/state/providers/messages.dart';
import 'package:taskbuddy/state/static/messages_state.dart';
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
  final ScrollController _scrollController = ScrollController();

  bool _hasMoreMessages = true;
  bool _loading = false;

  // Messages that are currently being sent
  List<String> _sending = [];

  Future<void> _markAsSeen() async {
    String token = (await AccountCache.getToken())!;
    // Mark as seen
    await Api.v1.channels.markAsSeen(token, widget.channel.uuid);
  }

  void _init() async {
    PublicAccountResponse otherUser = widget.channel.otherUser == "recipient" ? widget.channel.channelRecipient : widget.channel.channelCreator;

    if (
      widget.channel.lastMessages.isNotEmpty &&
      widget.channel.lastMessages.last.sender.UUID == otherUser.UUID &&
      !widget.channel.lastMessages.last.seen
    ) {
      _markAsSeen();
    }
  }

  void _onMessage(dynamic data) async {
    MessageResponse message = MessageResponse.fromJson(data["message"]);

    print("Received message: ${message.message}");

    if (message.channelUUID == widget.channel.uuid) {
      MessagesModel model = Provider.of<MessagesModel>(context, listen: false);

      setState(() {
        widget.channel.lastMessages.add(message);
      });

      _markAsSeen();
      model.setAsSeen(widget.channel);

      await Future.delayed(const Duration(milliseconds: 100));
      // Scroll to bottom
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  void _onSeen(dynamic data) async {
    if (data["channel_uuid"] == widget.channel.uuid) {
      MessagesModel model = Provider.of<MessagesModel>(context, listen: false);
      model.setAsSeen(widget.channel);

      setState(() {
        for (var message in widget.channel.lastMessages) {
          if (message.sender.isMe && !message.seen) {
            message.seen = true;
            message.seenAt = DateTime.now();
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

    MessagesState.currentChannel = widget.channel.uuid;

    _init();

    SocketClient.addListener("chat", _onMessage);
    SocketClient.addListener("channel_seen", _onSeen);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Mark as seen locally
      MessagesModel model = Provider.of<MessagesModel>(context, listen: false);
      model.setAsSeen(widget.channel);

      // Scroll to bottom when the page is loaded
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }

      // Lazy load more messages when the user scrolls to the top
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          return;
        }

        if (_scrollController.position.pixels == _scrollController.position.minScrollExtent && _hasMoreMessages && !_loading) {
          setState(() {
            _loading = true;
          });

          String token = (await AccountCache.getToken())!;

          // Get messages
          var result = await Api.v1.channels.messages.getMessages(
            token,
            widget.channel.uuid,
            widget.channel.lastMessages.length
          );

          if (result.ok) {
            if (result.data!.length == 0) {
              setState(() {
                _loading = false;
                _hasMoreMessages = false;
              });
            } else {
              List<MessageResponse> toAdd = [];

              // Don't add duplicates
              for (var message in result.data!.reversed) {
                if (!widget.channel.lastMessages.contains(message)) {
                  toAdd.add(message);
                }
              }

              setState(() {
                _loading = false;
                _hasMoreMessages = result.data!.length == 25;
                widget.channel.lastMessages.insertAll(0, toAdd);
              });
            }
          }
        }
      });
    });
  }

  @override
  void dispose() {
    SocketClient.disposeListener("chat", _onMessage);
    SocketClient.disposeListener("channel_seen", _onSeen);

    MessagesState.currentChannel = "";

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
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
                List<MessageResponse> lastMessages = widget.channel.lastMessages;
                bool showSeen = false;
                
                if (lastMessages.last.seen && lastMessages.last.sender.isMe && index == lastMessages.length - 1) {
                  showSeen = true;
                } else if (index < lastMessages.length - 1 && lastMessages[index].sender.isMe && lastMessages[index + 1].sender.isMe && !lastMessages[index + 1].seen) {
                  showSeen = true;
                }

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
                        message: widget.channel.lastMessages[index].message,
                        isMe: widget.channel.lastMessages[index].sender.isMe,
                        profilePicture: widget.channel.lastMessages[index].sender.profilePicture,
                        showSeen: showSeen,
                        showProfilePicture: showPfp,
                      ),
                    ],
                  );
                }

                return ChatBubble(
                  message: widget.channel.lastMessages[index].message,
                  isMe: widget.channel.lastMessages[index].sender.isMe,
                  profilePicture: widget.channel.lastMessages[index].sender.profilePicture,
                  seen: widget.channel.lastMessages[index].seen,
                  showSeen: showSeen,
                  showProfilePicture: showPfp,
                );
              },
            ),

            // Pending messages
            SliverList.builder(
              itemCount: _sending.length,
              itemBuilder: (context, index) {
                return Opacity(
                  opacity: 0.5,
                  child: ChatBubble(
                    message: _sending[index],
                    isMe: true,
                    profilePicture: "",
                    seen: false,
                    showSeen: false,
                    showProfilePicture: true,
                  ),
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

                      setState(() {
                        _sending.add(message);
                      });

                      // Scroll to bottom
                      if (widget.channel.lastMessages.isNotEmpty) {
                        await Future.delayed(const Duration(milliseconds: 100));
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }

                      String token = (await AccountCache.getToken())!;

                      // Send message
                      var result = await Api.v1.channels.messages.sendMessage(
                        token,
                        channelUUID: widget.channel.uuid,
                        message: message
                      );

                      if (result.ok) {
                        MessagesModel model = Provider.of<MessagesModel>(context, listen: false);
                        model.onMessage(widget.channel.uuid, result.data!);

                        setState(() {
                          _sending.remove(message);
                          widget.channel.lastMessages.add(result.data!);
                        });
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
