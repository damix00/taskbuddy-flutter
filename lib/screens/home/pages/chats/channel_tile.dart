import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/account/public_account_response.dart';
import 'package:taskbuddy/api/responses/chats/channel_response.dart';
import 'package:taskbuddy/api/responses/chats/message_response.dart';
import 'package:taskbuddy/screens/chat_screen.dart';
import 'package:taskbuddy/utils/dates.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/input/with_state/pfp_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChannelTile extends StatelessWidget {
  final ChannelResponse channel;

  const ChannelTile({Key? key, required this.channel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    PublicAccountResponse otherUser = channel.otherUser == "recipient" ? channel.channelRecipient : channel.channelCreator;
    MessageResponse? lastMessage = channel.lastMessages.isNotEmpty ? channel.lastMessages.last : null;

    var messageContent = lastMessage != null
      ? (
        lastMessage.deleted
          ? l10n.messageDeleted
          : lastMessage.message
      )
      : l10n.noMessagesYet;

    return Touchable(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (ctx) => ChatScreen(
              channel: channel.clone(),
            )
          )
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: ProfilePictureDisplay(size: 48, iconSize: 32, profilePicture: otherUser.profile.profilePicture)
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "@${channel.otherUserAccount.username}",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        channel.post.title,
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (channel.status == ChannelStatus.ACCEPTED)
                      Text(
                        " • ${l10n.accepted}",
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: Theme.of(context).colorScheme.primary
                        )
                      ),
                    if (channel.status == ChannelStatus.PENDING)
                      Text(
                        " • ${l10n.pending}",
                        style: Theme.of(context).textTheme.labelSmall
                      ),
                    if (channel.status == ChannelStatus.CANCELLED)
                      Text(
                        " • ${l10n.cancelled}",
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: Theme.of(context).colorScheme.error
                        )
                      ),
                    if (channel.status == ChannelStatus.REJECTED)
                      Text(
                        " • ${l10n.rejected}",
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: Theme.of(context).colorScheme.error
                        )
                      ),
                    if (channel.status == ChannelStatus.COMPLETED)
                      Text(
                        " • ${l10n.completed}",
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: Colors.green
                        )
                      ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        lastMessage != null
                          ? lastMessage.sender != null
                            ? lastMessage.request != null
                              ? l10n.userSentAMessage(lastMessage.sender!.firstName)
                              : (
                                lastMessage.sender!.UUID == otherUser.UUID
                                  ? "${lastMessage.sender!.firstName}: $messageContent"
                                  : l10n.youMessage(messageContent)
                              )
                            : messageContent
                          : l10n.noMessagesYet,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: (lastMessage != null && !lastMessage.seen && lastMessage.sender != null && lastMessage.sender!.UUID == otherUser.UUID)
                            ? FontWeight.w600
                            : FontWeight.w400,
                          color: (lastMessage != null && !lastMessage.seen && lastMessage.sender != null && lastMessage.sender!.UUID == otherUser.UUID)
                            ? Theme.of(context).colorScheme.onBackground
                            : Theme.of(context).textTheme.labelMedium!.color,
                          fontStyle: lastMessage != null && lastMessage.deleted ? FontStyle.italic : FontStyle.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    // Show the time of the last message
                    if (lastMessage != null)
                      Text(
                        " • ${Dates.timeAgo(channel.lastMessageTime, Localizations.localeOf(context))}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: (lastMessage.sender != null && lastMessage.sender!.UUID == otherUser.UUID && !lastMessage.seen) ? FontWeight.w600 : FontWeight.w400,
                          color: (lastMessage.sender != null && lastMessage.sender!.UUID == otherUser.UUID && !lastMessage.seen)
                            ? Theme.of(context).colorScheme.onBackground
                            : Theme.of(context).textTheme.labelMedium!.color
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}