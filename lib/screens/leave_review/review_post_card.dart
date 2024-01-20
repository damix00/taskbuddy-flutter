import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/account/public_account_response.dart';
import 'package:taskbuddy/api/responses/posts/post_only_response.dart';
import 'package:taskbuddy/widgets/ui/platforms/loader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReviewPostCard extends StatelessWidget {
  final PostOnlyResponse post;
  final bool isEmployee;
  final PublicAccountResponse otherUser;

  const ReviewPostCard({
    super.key,
    required this.post,
    required this.isEmployee,
    required this.otherUser,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 80,
            height: 80,
            child: CachedNetworkImage(
              imageUrl: post.media[0],
              fit: BoxFit.cover,
              placeholder: (context, url) => const CrossPlatformLoader(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isEmployee ? l10n.youWorkedFor(otherUser.username) : l10n.youHired(otherUser.username),
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Text(
                post.title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                post.description,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
