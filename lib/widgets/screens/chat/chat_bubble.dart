import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/chats/message_response.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/input/with_state/pfp_input.dart';

class ChatBubble extends StatelessWidget {
  final MessageResponse message;
  final bool showProfilePicture;
  final bool showSeen;

  const ChatBubble({
    Key? key,
    required this.message,
    this.showProfilePicture = true,
    this.showSeen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: message.sender.isMe ? 16 : 8, vertical: 4),
      child: Column(
        crossAxisAlignment: message.sender.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: message.sender.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!message.sender.isMe)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: showProfilePicture ? ProfilePictureDisplay(
                      size: 28,
                      iconSize: 14,
                      profilePicture: message.sender.profilePicture
                    ) : null,
                  ),
                ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: message.sender.isMe
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: Text(
                    message.deleted ? l10n.messageDeleted : message.message,
                    style: TextStyle(
                      color: message.sender.isMe
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ],
          ),
          showSeen && message.sender.isMe ? Padding(
            padding: const EdgeInsets.only(left: 48.0, top: 4),
            child: Text(
              l10n.seen,
              style: Theme.of(context).textTheme.labelSmall
            )
          ) : Container(),
        ],
      ),
    );
  }
}
