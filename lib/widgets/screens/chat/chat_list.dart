import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/chats/message_response.dart';
import 'package:taskbuddy/utils/dates.dart';
import 'package:taskbuddy/widgets/screens/chat/chat_bubble.dart';

class ChatList extends StatelessWidget {
  final List<MessageResponse> lastMessages;
  final Function(GlobalKey, MessageResponse) onSelected;
  final MessageResponse? currentMessage;

  const ChatList({
    Key? key,
    required this.lastMessages,
    required this.onSelected,
    this.currentMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: lastMessages.length,
      itemBuilder: (context, index) {
        if (lastMessages[index].sender == null) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Center(
              child: Text(
                lastMessages[index].message,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          );
        }

        GlobalKey bubbleKey = GlobalKey();

        bool showSeen = false;

        if (lastMessages.last.seen && lastMessages.last.sender!.isMe && index == lastMessages.length - 1) {
          showSeen = true;
        } else if (
          index < lastMessages.length - 1 &&
          lastMessages.last.sender != null &&
          lastMessages[index].sender!.isMe &&
          lastMessages[index + 1].sender != null && 
          lastMessages[index + 1].sender!.isMe &&
          !lastMessages[index + 1].seen
        ) {
          showSeen = true;
        }

        bool showPfp = index == lastMessages.length - 1 ||
          lastMessages[index + 1].sender == null ||
          lastMessages[index + 1].sender!.UUID != lastMessages[index].sender!.UUID;

        
        var message = lastMessages[index];

        // Show date header
        if (index == 0 || lastMessages[index].createdAt.day != lastMessages[index - 1].createdAt.day) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  Dates.formatDate(lastMessages[index].createdAt, showTime: false),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              GestureDetector(
                onLongPress: () {
                  onSelected(bubbleKey, message);
                },
                child: Opacity(
                  opacity: currentMessage == message ? 0 : 1,
                  child: ChatBubble(
                    key: bubbleKey,
                    message: message.message,
                    isMe: message.sender!.isMe,
                    profilePicture: message.sender!.profilePicture,
                    showSeen: showSeen,
                    showProfilePicture: showPfp,
                    deleted: message.deleted,
                    messageRequest: message.request,
                    messageResponse: message
                  ),
                ),
              ),
            ],
          );
        }

        return GestureDetector(
          onLongPress: () {
            onSelected(bubbleKey, message);
          },
          child: Opacity(
            opacity: currentMessage == message ? 0 : 1,
            child: ChatBubble(
              key: bubbleKey,
              message: message.message,
              isMe: message.sender!.isMe,
              profilePicture: message.sender!.profilePicture,
              seen: message.seen,
              showSeen: showSeen,
              showProfilePicture: showPfp,
              deleted: message.deleted,
              messageRequest: message.request,
              messageResponse: message
            ),
          ),
        );
      },
    );
  }
}
