import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/posts/post_results_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/screens/profile_screen.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/slim_button.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/input/with_state/pfp_input.dart';
import 'package:taskbuddy/widgets/ui/feedback/snackbars.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostAuthor extends StatefulWidget {
  final PostResultsResponse post;
  final bool rightPadding;

  const PostAuthor({ Key? key, required this.post, this.rightPadding = true }) : super(key: key);

  @override
  State<PostAuthor> createState() => _PostAuthorState();
}

class _PostAuthorState extends State<PostAuthor> {
  late bool _following;

  @override
  void initState() {
    super.initState();

    _following = widget.post.user.isFollowing;
  }

  void _openProfile() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ProfileScreen(
          UUID: widget.post.user.UUID,
          username: widget.post.user.username,
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return SizedBox(
      height: 36,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(left: Sizing.horizontalPadding, right: Sizing.horizontalPadding + (widget.rightPadding ? Sizing.interactionsWidth : 0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Touchable(
              onTap: _openProfile,
              child: SizedBox(
                width: 36,
                height: 36,
                child: ProfilePictureDisplay(size: 36, iconSize: 20, profilePicture: widget.post.user.profilePicture)
              ),
            ),
            const SizedBox(width: 12,),
            Expanded(
              child: Touchable(
                onTap: _openProfile,
                child: Text(
                  "@${widget.post.user.username}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
            if (widget.post.user.verified)
              const SizedBox(width: 4,),
            if (widget.post.user.verified)
              const Icon(Icons.verified, size: 16, color: Colors.blue,),
    
            if (!widget.post.user.isMe)
              const SizedBox(width: 12,),
            if (!widget.post.user.isMe)
              FeedSlimButton(
                onPressed: () async {
                  String token = (await AccountCache.getToken())!;

                  bool res = false;

                  if (_following) {
                    res = await Api.v1.accounts.unfollow(token, widget.post.user.UUID);
                  } else {
                    res = await Api.v1.accounts.follow(token, widget.post.user.UUID);
                  }

                  if (!res) {
                    SnackbarPresets.error(context, l10n.somethingWentWrong);
                    return;
                  }

                  setState(() {
                    _following = !_following;
                  });
                },
                child: Text(
                  _following ? l10n.unfollow : l10n.follow,
                )
              )
          ],
        ),
      ),
    );
  }
}