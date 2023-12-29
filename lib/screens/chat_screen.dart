import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/posts/post_results_response.dart';
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
                    " • €${price}",
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
  final String? channelUuid;
  final String currentUserUuid;
  final PostResultsResponse post;
  final bool isChannelCreated;
  final bool isPostCreator;

  const ChatScreen({
    Key? key,
    this.channelUuid,
    required this.currentUserUuid,
    required this.post,
    this.isChannelCreated = true,
    this.isPostCreator = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: Touchable(
          onTap: () => {
            Navigator.of(context).push(
              CupertinoPageRoute(builder: (context) => ProfileScreen(
                UUID: post.user.UUID,
                username: post.user.username,
              ))
            )
          },
          child: ChatScreenAppbar(
            profilePicture: post.user.profilePicture,
            title: post.title,
            price: post.price.toString(),
            firstName: post.user.firstName,
            lastName: post.user.lastName
          )
        )
      ),
    );
  }
}