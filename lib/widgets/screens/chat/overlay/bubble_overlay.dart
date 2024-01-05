import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/chats/message_response.dart';
import 'package:taskbuddy/widgets/screens/chat/chat_bubble.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BubbleOverlay extends StatefulWidget {
  final MessageResponse message;
  final double y;

  const BubbleOverlay({
    Key? key,
    required this.message,
    required this.y
  }) : super(key: key);

  @override
  State<BubbleOverlay> createState() => _BubbleOverlayState();
}

class _BubbleOverlayState extends State<BubbleOverlay> {
  double _y = 0;

  @override
  void initState() {
    super.initState();
    
    _y = widget.y;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var height = MediaQuery.of(context).size.height;

      if (_y > height - 200) {
        setState(() {
          _y = height - 200;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    double horizontalPadding = widget.message.sender.isMe ? 16 : 56;

    return AnimatedPositioned(
      top: _y,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: widget.message.sender.isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            ChatBubble(
              message: widget.message.message,
              isMe: widget.message.sender.isMe,
              profilePicture: widget.message.sender.profilePicture,
              seen: widget.message.seen,
              showSeen: true,
              showProfilePicture: true,
              showTime: true,
              sentAt: widget.message.createdAt,
              seenAt: widget.message.seenAt,
            ),
            if (widget.message.seen && !widget.message.sender.isMe)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Text(
                  l10n.sent,
                  style: Theme.of(context).textTheme.labelSmall
                ),
              ),
          ],
        ),
      ),
    );
  }
}
