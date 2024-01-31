import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/api/responses/chats/channel_response.dart';
import 'package:taskbuddy/api/responses/chats/message_response.dart';
import 'package:taskbuddy/screens/chat/attachment_view_screen.dart';
import 'package:taskbuddy/utils/dates.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/input/with_state/pfp_input.dart';
import 'package:taskbuddy/widgets/screens/chat/request_messages/request_message.dart';
import 'package:taskbuddy/widgets/transitions/fade_in.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageAttachments extends StatelessWidget {
  final List<MessageAttachment> attachments;

  const MessageAttachments({
    Key? key,
    required this.attachments
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 12),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: attachments.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8
          ),
          itemBuilder: (context, index) {
            if (attachments[index].type == MessageAttachment.IMAGE) {
              return Touchable(
                onTap: () {
                  Navigator.of(context).push(
                    FadeInPageRoute(
                      builder: (context) => AttachmentViewScreen(
                        attachments: attachments,
                        index: index
                      )
                    )
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Hero(
                    tag: attachments[index].url,
                    child: CachedNetworkImage(
                      imageUrl: attachments[index].url,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }

            else if (attachments[index].type == MessageAttachment.VIDEO) {
              return Touchable(
                onTap: () {
                  Navigator.of(context).push(
                    FadeInPageRoute(
                      builder: (context) => AttachmentViewScreen(
                        attachments: attachments,
                        index: index
                      )
                    )
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    children: [
                      Container(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Positioned.fill(
                        child: Icon(
                          Icons.play_arrow_outlined,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 48,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }

            return Touchable(
              onTap: () async {
                // Open link in browser
                await launchUrl(
                  Uri.parse(attachments[index].url),
                  mode: LaunchMode.externalApplication
                );
              },
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Positioned.fill(
                    child: Icon(
                      Icons.insert_drive_file_outlined,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 32,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Icon(
                      Icons.open_in_browser_outlined,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 20
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final String profilePicture;
  final DateTime? seenAt;
  final DateTime? sentAt;
  final bool isMe;
  final bool showProfilePicture;
  final bool showSeen;
  final bool deleted;
  final bool seen;
  final bool showTime;
  final MessageRequest? messageRequest;
  final MessageResponse? messageResponse;
  final ChannelResponse? channelResponse;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isMe,
    this.showProfilePicture = true,
    this.showSeen = false,
    this.profilePicture = "",
    this.deleted = false,
    this.seen = false,
    this.showTime = false,
    this.seenAt,
    this.sentAt,
    this.messageRequest,
    this.messageResponse,
    this.channelResponse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMe ? 16 : 8, vertical: 4),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isMe)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: showProfilePicture ? ProfilePictureDisplay(
                      size: 28,
                      iconSize: 14,
                      profilePicture: profilePicture
                    ) : null,
                  ),
                ),
              const SizedBox(width: 8),
              messageRequest != null && !deleted
                ? Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: RequestMessageWidget(
                      message: messageResponse!,
                      channel: channelResponse!,
                    ),
                  )
                : Column(
                    crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (messageResponse!.attachments.isNotEmpty)
                        MessageAttachments(
                          attachments: messageResponse!.attachments
                        ),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isMe
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          child: Text(
                            deleted ? l10n.messageDeleted : message,
                            style: TextStyle(
                              color: isMe
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                              fontStyle: deleted ? FontStyle.italic : FontStyle.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
            ],
          ),
          showSeen && seen && isMe ? Padding(
            padding: const EdgeInsets.only(left: 48.0, top: 4),
            child: Text(
              "${l10n.seen}${showTime ? " ${Dates.formatDateCompact(seenAt!)}" : ""}",
              style: Theme.of(context).textTheme.labelSmall
            )
          ) : Container(),
        ],
      ),
    );
  }
}
