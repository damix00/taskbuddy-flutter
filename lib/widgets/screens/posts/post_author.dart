import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/posts/post_results_response.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/slim_button.dart';
import 'package:taskbuddy/widgets/input/with_state/pfp_input.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostAuthor extends StatelessWidget {
  final PostResultsResponse post;

  const PostAuthor({ Key? key, required this.post }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 36,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: Sizing.horizontalPadding, right: Sizing.horizontalPadding + Sizing.interactionsWidth),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 36,
              height: 36,
              child: ProfilePictureDisplay(size: 36, iconSize: 20, profilePicture: post.user.profilePicture)
            ),
            const SizedBox(width: 12,),
            Flexible(
              child: Text(
                "@${post.user.username}",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            if (post.user.verified)
              const SizedBox(width: 4,),
            if (post.user.verified)
              const Icon(Icons.verified, size: 16, color: Colors.blue,),
    
            if (!post.user.isFollowing && !post.user.isMe)
              const SizedBox(width: 12,),
            if (!post.user.isFollowing && !post.user.isMe)
              FeedSlimButton(onPressed: () {}, child: Text(l10n.follow))
          ],
        ),
      ),
    );
  }
}