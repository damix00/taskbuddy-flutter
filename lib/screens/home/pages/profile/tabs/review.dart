import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/reviews/review_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/screens/profile/profile_screen.dart';
import 'package:taskbuddy/utils/dates.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/input/with_state/expandable.dart';
import 'package:taskbuddy/widgets/input/with_state/pfp_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/overlays/dialog/report_dialog.dart';
import 'package:taskbuddy/widgets/overlays/loading_overlay.dart';
import 'package:taskbuddy/widgets/ui/feedback/snackbars.dart';
import 'package:taskbuddy/widgets/ui/platforms/bottom_sheet.dart';

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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "\"${review.postTitle}\"",
                style: Theme.of(context).textTheme.labelMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "${review.user.firstName} ${review.user.lastName}",
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "${review.type == ReviewType.EMPLOYER
                  ? l10n.hiredUser(otherUsername)
                  : l10n.workedForUser(otherUsername)
                } · ${Dates.formatDate(review.createdAt, showTime: false)}",
                style: Theme.of(context).textTheme.labelSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class Review extends StatelessWidget {
  final ReviewResponse review;
  final String otherUsername;
  final VoidCallback? onDeleted;

  const Review({
    Key? key,
    required this.review,
    required this.otherUsername,
    this.onDeleted
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Touchable(
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
            ),
            IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              onPressed: () async {
                CrossPlatformBottomSheet.showModal(
                  context,
                  [
                    BottomSheetButton(
                      title: l10n.report,
                      icon: Icons.flag_outlined,
                      onTap: (c) {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            shadowColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            surfaceTintColor: Colors.transparent,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: ReportDialog(
                                UUID: review.UUID,
                                type: ReportType.review,
                              ),
                            ),
                          )
                        );
                      }
                    ),
                    if (review.user.isMe)
                      BottomSheetButton(
                        title: l10n.deleteText,
                        icon: Icons.delete_outline,
                        onTap: (c) async {
                          LoadingOverlay.showLoader(context);

                          bool res = await Api.v1.reviews.deleteReview(
                            (await AccountCache.getToken())!,
                            review.UUID
                          );

                          LoadingOverlay.hideLoader(context);

                          if (!res) {
                            SnackbarPresets.error(
                              context,
                              l10n.somethingWentWrong
                            );
                          } else {
                            onDeleted?.call();
                            SnackbarPresets.show(context, text: l10n.successfullyDeleted);
                          }
                        }
                      )
                  ]
                );
              }
            )
          ],
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
