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
import 'package:taskbuddy/widgets/screens/chat/menu/menu_sheet.dart';
import 'package:taskbuddy/widgets/screens/chat/overlay/bubble_overlay.dart';
import 'package:taskbuddy/widgets/screens/chat/overlay/chat_screen_overlay.dart';

class ChatLayout extends StatefulWidget {
  final ChannelResponse channel;

  const ChatLayout({
    Key? key,
    required this.channel
  }) : super(key: key);

  @override
  State<ChatLayout> createState() => _ChatLayoutState();
}

class _ChatLayoutState extends State<ChatLayout> with WidgetsBindingObserver {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _hasMoreMessages = true;
  bool _loading = false;

  // Messages that are currently being sent
  List<String> _sending = [];

  int _messageY = 0;

  MessageResponse? _currentMessage;

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
      // check if the message is already in the list
      if (widget.channel.lastMessages.contains(message)) {
        return;
      }

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

  void _onDeleted(dynamic data) async {
    if (data["channel_uuid"] == widget.channel.uuid) {
      setState(() {
        for (var message in widget.channel.lastMessages) {
          if (message.UUID == data["message_uuid"]) {
            message.deleted = true;
          }
        }
      });
    }
  }

  void _addMessage(MessageResponse message) {
    MessagesModel model = Provider.of<MessagesModel>(context, listen: false);

    model.onMessage(widget.channel.uuid, message);
    model.sortChannels();

    setState(() {
      widget.channel.lastMessages.add(message);
    });
  }

  Future<void> _sendMessage(String message) async {
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
        model.sortChannels();

        setState(() {
          _sending.remove(message);
          widget.channel.lastMessages.add(result.data!);
        });
      }
    }
  }

  void _showMenu(GlobalKey key, MessageResponse message) {
    var pos = key.currentContext!.findRenderObject() as RenderBox;
    
    setState(() {
      _messageY = pos.localToGlobal(Offset.zero).dy.toInt();
      _currentMessage = message;
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    MessagesState.currentChannel = widget.channel.uuid;

    _init();

    SocketClient.addListener("chat", _onMessage);
    SocketClient.addListener("channel_seen", _onSeen);
    SocketClient.addListener("message_deleted", _onDeleted);

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

        if (_scrollController.position.pixels > _scrollController.position.minScrollExtent - 50 && _hasMoreMessages && !_loading) {
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
            if (result.data!.isEmpty) {
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

              model.insertMessages(result.data!);
              model.sortChannels();

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
    SocketClient.disposeListener("message_deleted", _onDeleted);

    MessagesState.currentChannel = "";

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final value = MediaQuery.of(context).viewInsets.bottom;

    if (value > 0) {
      // Keyboard is visible
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        MessagesState.currentChannel = "";

        if (_currentMessage != null) {
          setState(() {
            _currentMessage = null;
          });
          return false;
        }

        return true;
      },
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                    GlobalKey bubbleKey = GlobalKey();
    
                    List<MessageResponse> lastMessages = widget.channel.lastMessages;
                    bool showSeen = false;
                    
                    if (lastMessages.last.seen && lastMessages.last.sender.isMe && index == lastMessages.length - 1) {
                      showSeen = true;
                    } else if (index < lastMessages.length - 1 && lastMessages[index].sender.isMe && lastMessages[index + 1].sender.isMe && !lastMessages[index + 1].seen) {
                      showSeen = true;
                    }
          
                    bool showPfp = index == widget.channel.lastMessages.length - 1 ||
                      widget.channel.lastMessages[index + 1].sender.UUID != widget.channel.lastMessages[index].sender.UUID;
    
                    
                    var message = widget.channel.lastMessages[index];
          
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
                          GestureDetector(
                            onLongPress: () {
                              _showMenu(bubbleKey, message);
                            },
                            child: Opacity(
                              opacity: _currentMessage == message ? 0 : 1,
                              child: ChatBubble(
                                key: bubbleKey,
                                message: message.message,
                                isMe: message.sender.isMe,
                                profilePicture: message.sender.profilePicture,
                                showSeen: showSeen,
                                showProfilePicture: showPfp,
                                deleted: message.deleted,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
          
                    return GestureDetector(
                      onLongPress: () {
                        _showMenu(bubbleKey, message);
                      },
                      child: Opacity(
                        opacity: _currentMessage == message ? 0 : 1,
                        child: ChatBubble(
                          key: bubbleKey,
                          message: message.message,
                          isMe: message.sender.isMe,
                          profilePicture: message.sender.profilePicture,
                          seen: message.seen,
                          showSeen: showSeen,
                          showProfilePicture: showPfp,
                          deleted: message.deleted,
                        ),
                      ),
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
          ),
          Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 0,
            right: 0,
            child: BlurParent(
              blurColor: Theme.of(context).colorScheme.background.withOpacity(0.75),
              noBlurColor: Theme.of(context).colorScheme.background,
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  height: MediaQuery.of(context).padding.bottom + 44 + 12,
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 12,
                    left: 16,
                    right: 16,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(32)),
                    child: BlurParent(
                      child: ChatInput(
                        controller: _textController,
                        onSend: _sendMessage,
                        onMorePressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context,) {
                              return MenuSheet(
                                channel: widget.channel,
                                onMessage: _addMessage
                              );
                            }
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            )
          ),
          ChatScreenOverlay(
            show: _currentMessage != null,
            onDismiss: () {
              setState(() {
                _currentMessage = null;
              });
            }
          ),
          if (_currentMessage != null)
            BubbleOverlay(
              message: _currentMessage!,
              y: _messageY.toDouble(),
              onDismiss: () {
                setState(() {
                  _currentMessage = null;
                });
              },
            ),
        ],
      ),
    );
  }
}
