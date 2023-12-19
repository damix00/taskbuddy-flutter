import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/posts/post_response.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/state/static/create_post_state.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class PostJobType extends StatelessWidget {
  final PostResponse post;

  const PostJobType({ Key? key, required this.post }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    var postType = l10n.oneTimeJob;

    if (post.jobType == PostType.partTime) {
      postType = l10n.partTimeJob;
    } else if (post.jobType == PostType.fullTime) {
      postType = l10n.fullTimeJob;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
      child: Text(
        postType.toUpperCase(),
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}