import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:taskbuddy/api/responses/reviews/review_response.dart';
import 'package:taskbuddy/screens/profile/profile_screen.dart';
import 'package:taskbuddy/utils/dates.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/input/with_state/expandable.dart';
import 'package:taskbuddy/widgets/input/with_state/pfp_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReviewAccountData extends StatelessWidget {
  final ReviewResponse review;
  final String otherUsername;

  const ReviewAccountData({
    super.key,
    required this.review,
    required this.otherUsername,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 42,
          height: 42,
          child: ProfilePictureDisplay(
            size: 42,
            iconSize: 20,
            profilePicture: review.user.profile.profilePicture
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(review.postTitle, style: Theme.of(context).textTheme.labelMedium),
            Text(
              "${review.user.firstName} ${review.user.lastName}",
              style: Theme.of(context).textTheme.bodyLarge
            ),
            Text(
              "${review.type == ReviewType.EMPLOYER
                ? l10n.hiredUser(otherUsername)
                : l10n.workedForUser(otherUsername)
              } · ${Dates.formatDate(review.createdAt, showTime: false)}",
              style: Theme.of(context).textTheme.labelSmall
            ),
          ],
        )
      ],
    );
  }
}

class Review extends StatelessWidget {
  final ReviewResponse review;
  final String otherUsername;

  const Review({ Key? key, required this.review, required this.otherUsername }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Touchable(
          onTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => ProfileScreen(
                  UUID: review.user.UUID,
                  username: review.user.username,
                )
              )
            );
          },
          child: ReviewAccountData(
            review: review,
            otherUsername: otherUsername
          ),
        ),
        const SizedBox(height: 8),
        RatingBarIndicator(
          rating: review.rating.toDouble(),
          itemBuilder: (context, index) => Icon(
            Icons.star_rate,
            color: Theme.of(context).colorScheme.primary,
          ),
          unratedColor: Theme.of(context).colorScheme.onSurfaceVariant,
          itemCount: 5,
          itemSize: 24,
          direction: Axis.horizontal,
        ),
        const SizedBox(height: 8),
        Text(
          review.title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(height: review.description.isNotEmpty ? 4 : 0),

        if (review.description.isNotEmpty)
          Expandable(
            text: review.description,
            style: Theme.of(context).textTheme.labelMedium,
            initiallyExpanded: false,
          ),
      ],
    );
  }
}
