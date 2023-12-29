import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/account/public_account_response.dart';
import 'package:taskbuddy/api/responses/chats/channel_response.dart';
import 'package:taskbuddy/screens/profile_screen.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/input/with_state/pfp_input.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';

class ChatScreenAppbar extends StatelessWidget {
  final String profilePicture;
  final String title;
  final String price;
  final String firstName;
  final String lastName;

  const ChatScreenAppbar({
    Key? key,
    required this.profilePicture,
    required this.title,
    required this.price,
    required this.firstName,
    required this.lastName
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: ProfilePictureDisplay(
            size: 32,
            iconSize: 20,
            profilePicture: profilePicture
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    " • €$price",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w900
                    )
                  )
                ],
              ),
              Text(
                "${firstName} ${lastName}",
                style: Theme.of(context).textTheme.labelSmall
              )
            ],
          ),
        ),
        const SizedBox(width: 24,)
      ],
      );
  }
}

class ChatScreen extends StatelessWidget {
  final ChannelResponse channel;

  const ChatScreen({
    Key? key,
    required this.channel
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PublicAccountResponse otherUser = channel.otherUser == "recipient" ? channel.channelRecipient : channel.channelCreator;

    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: Touchable(
          onTap: () => {
            Navigator.of(context).push(
              CupertinoPageRoute(builder: (context) => ProfileScreen(
                account: otherUser
              ))
            )
          },
          child: ChatScreenAppbar(
            profilePicture: otherUser.profile.profilePicture,
            title: channel.post.title,
            price: channel.post.price.toString(),
            firstName: otherUser.firstName,
            lastName: otherUser.lastName
          )
        )
      ),
    );
  }
}