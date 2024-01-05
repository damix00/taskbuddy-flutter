import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskbuddy/api/responses/chats/message_response.dart';
import 'package:taskbuddy/widgets/screens/chat/chat_bubble.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/screens/chat/overlay/chat_menu_button.dart';

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

    double leftPadding = widget.message.sender.isMe ? 0 : 56;
    double rightPadding = widget.message.sender.isMe ? 16 : 0;

    CrossAxisAlignment crossAlignment = widget.message.sender.isMe
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;

    return AnimatedPositioned(
      top: _y,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: crossAlignment,
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
            if (!widget.message.seen && widget.message.sender.isMe)
              Padding(
                padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
                child: Text(
                  l10n.sent,
                  style: Theme.of(context).textTheme.labelSmall
                ),
              ),

            Container(
              width: 156 + leftPadding + rightPadding,
              constraints: BoxConstraints(
                maxHeight: (MediaQuery.of(context).size.height - _y) / 2,
                maxWidth: MediaQuery.of(context).size.width
              ),
              child: ListView(
                padding: EdgeInsets.only(left: leftPadding, right: rightPadding, top: 8),
                children: [
                  ChatMenuButton(
                    text: l10n.copy,
                    icon: Icons.copy_outlined,
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: widget.message.message));
                    },
                  ),
              
                  if (widget.message.sender.isMe)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: ChatMenuButton(
                        text: l10n.deleteText,
                        icon: Icons.delete_outline,
                        onTap: () {
                          // widget.message.delete();
                        },
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
