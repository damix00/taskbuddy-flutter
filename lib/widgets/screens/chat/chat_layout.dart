import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/chats/channel_response.dart';

class ChatLayout extends StatelessWidget {
  final ChannelResponse channel;

  const ChatLayout({
    Key? key,
    required this.channel
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}