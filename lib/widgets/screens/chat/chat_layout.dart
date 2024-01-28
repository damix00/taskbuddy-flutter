import 'dart:async';
import 'dart:developer';

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
import 'package:taskbuddy/widgets/navigation/blur_parent.dart';
import 'package:taskbuddy/widgets/screens/chat/chat_bubble.dart';
import 'package:taskbuddy/widgets/screens/chat/chat_input.dart';
import 'package:taskbuddy/widgets/screens/chat/chat_list.dart';
import 'package:taskbuddy/widgets/screens/chat/chat_post_info.dart';
import 'package:taskbuddy/widgets/screens/chat/menu/menu_sheet.dart';
import 'package:taskbuddy/widgets/screens/chat/overlay/bubble_overlay.dart';
import 'package:taskbuddy/widgets/screens/chat/overlay/chat_screen_overlay.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/ui/feedback/snackbars.dart';

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
  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 0,
    keepScrollOffset: true
  );

  bool _hasMoreMessages = true;
  bool _loading = false;

  // Messages that are currently being sent
  List<String> _sending = [];

  late ChannelResponse channel;

  int _messageY = 0;

  MessageResponse? _currentMessage;

  Future<void> _markAsSeen() async {
    String token = (await AccountCache.getToken())!;
    // Mark as seen
    await Api.v1.channels.markAsSeen(token, channel.uuid);
  }

  void _init() async {
    PublicAccountResponse otherUser = channel.otherUser == "recipient" ? channel.channelRecipient : channel.channelCreator;

    if (
      widget.channel.lastMessages.isNotEmpty &&
      widget.channel.lastMessages.last.sender != null &&
      widget.channel.lastMessages.last.sender!.UUID == otherUser.UUID &&
      !widget.channel.lastMessages.last.seen
    ) {
      _markAsSeen();
    }
  }

  void _onMessage(dynamic data) async {
    MessageResponse message = MessageResponse.fromJson(data["message"]);

    log("Received message: ${message.message}");

    if (message.channelUUID == channel.uuid) {
      // check if the message is already in the list
      if (widget.channel.lastMessages.contains(message)) {
        return;
      }

      MessagesModel model = Provider.of<MessagesModel>(context, listen: false);

      setState(() {
        widget.channel.lastMessages.add(message);
      });

      _markAsSeen();
      model.setAsSeen(channel.uuid);

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
    if (data["channel_uuid"] == channel.uuid) {
      MessagesModel model = Provider.of<MessagesModel>(context, listen: false);
      model.setAsSeen(channel.uuid);

      setState(() {
        for (var message in widget.channel.lastMessages) {
          if (message.sender != null && message.sender!.isMe && !message.seen) {
            message.seen = true;
            message.seenAt = DateTime.now();
          }
        }
      });

      await Future.delayed(const Duration(milliseconds: 100));

      // Scroll to bottom
      if (_scrollController.hasClients && _scrollController.position.pixels > _scrollController.position.maxScrollExtent - 100) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  void _onDeleted(dynamic data) async {
    if (data["channel_uuid"] == channel.uuid) {
      setState(() {
        for (var message in widget.channel.lastMessages) {
          if (message.UUID == data["message_uuid"]) {
            message.deleted = true;
          }
        }
      });
    }
  }

  void _onUpdated(dynamic data) async {
    var msg = MessageResponse.fromJson(data["message"]);

    if (msg.channelUUID != channel.uuid) {
      return;
    }

    var index = widget.channel.lastMessages.indexWhere((element) => element.UUID == msg.UUID);

    if (index == -1) {
      log("Message not found");
      return;
    }

    setState(() {
      widget.channel.lastMessages[index] = msg;
    });
  }

  void _onChannelUpdate(dynamic data) async {
    var _channel = ChannelResponse.fromJson(data["channel"]);

    if (_channel.uuid != channel.uuid) {
      return;
    }

    setState(() {
      channel = _channel;
    });
  }

  void _addMessage(MessageResponse message) async {
    MessagesModel model = Provider.of<MessagesModel>(context, listen: false);

    model.onMessage(channel.uuid, message);
    model.sortChannels();

    setState(() {
      widget.channel.lastMessages.add(message);
    });

    // Scroll to bottom
    if (widget.channel.lastMessages.isNotEmpty &&
      _scrollController.hasClients &&
      _scrollController.position.pixels > _scrollController.position.maxScrollExtent - 400
    ) {
      await Future.delayed(const Duration(milliseconds: 100));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage(String message) async {
    AppLocalizations l10n = AppLocalizations.of(context)!;

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
        channelUUID: channel.uuid,
        message: message
      );

      if (result.ok) {
        MessagesModel model = Provider.of<MessagesModel>(context, listen: false);

        model.onMessage(channel.uuid, result.data!);
        model.sortChannels();

        setState(() {
          _sending.remove(message);
          widget.channel.lastMessages.add(result.data!);
        });
      }

      else {
        SnackbarPresets.error(context, l10n.somethingWentWrong);
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

    channel = widget.channel;

    _init();

    SocketClient.addListener("chat", _onMessage);
    SocketClient.addListener("channel_seen", _onSeen);
    SocketClient.addListener("message_deleted", _onDeleted);
    SocketClient.addListener("message_updated", _onUpdated);
    SocketClient.addListener("channel_update", _onChannelUpdate);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Mark as seen locally
      MessagesModel model = Provider.of<MessagesModel>(context, listen: false);
      model.setAsSeen(channel.uuid);

      // Scroll to bottom when the page is loaded
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

        Future.delayed(const Duration(milliseconds: 100))
          .then((value) =>
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            )
          );
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
            channel.uuid,
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
    SocketClient.disposeListener("message_updated", _onUpdated);
    SocketClient.disposeListener("channel_update", _onChannelUpdate);

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
    AppLocalizations l10n = AppLocalizations.of(context)!;

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
              shrinkWrap: true,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(height: MediaQuery.of(context).padding.top),
                ),
                SliverToBoxAdapter(
                  child: ChatPostInfo(channel: channel),
                ),
          
                // Chat messages
                ChatList(
                  lastMessages: widget.channel.lastMessages,
                  onSelected: _showMenu,
                  currentMessage: _currentMessage,
                  channel: channel,
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
            child: channel.status != ChannelStatus.REJECTED
              ? BlurParent(
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
                                    channel: channel,
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
                : SafeArea(
                  child: Center(
                    child: Text(
                      l10n.noLongerSend,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium
                    ),
                  )
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
              channel: channel,
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
