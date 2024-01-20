import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:taskbuddy/api/responses/account/public_account_response.dart';
import 'package:taskbuddy/api/responses/posts/post_only_response.dart';
import 'package:taskbuddy/screens/leave_review/review_post_card.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/with_state/text_inputs/input_title.dart';
import 'package:taskbuddy/widgets/input/with_state/text_inputs/text_input.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/ui/feedback/snackbars.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:taskbuddy/widgets/ui/visual/divider.dart';

class LeaveReviewScreen extends StatelessWidget {
  final PublicAccountResponse user;
  final PublicAccountResponse otherUser;
  final PostOnlyResponse post;
  final bool isEmployee;

  const LeaveReviewScreen({
    Key? key,
    required this.user,
    required this.otherUser,
    required this.post,
    required this.isEmployee,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BlurAppbar.appBar(
        child: AppbarTitle(
          l10n.leaveAReview
        )
      ),
      body: SingleChildScrollView(
        child: _ReviewScreenContent(
          user: user,
          otherUser: otherUser,
          post: post,
          isEmployee: isEmployee,
        ),
      )
    );
  }
}

class _ReviewScreenContent extends StatefulWidget {
  final PublicAccountResponse user;
  final PublicAccountResponse otherUser;
  final PostOnlyResponse post;
  final bool isEmployee;

  const _ReviewScreenContent({
    Key? key,
    required this.user,
    required this.otherUser,
    required this.post,
    required this.isEmployee,
  }) : super(key: key);

  @override
  State<_ReviewScreenContent> createState() => _ReviewScreenContentState();
}

class _ReviewScreenContentState extends State<_ReviewScreenContent> {
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      child: Padding(
        padding: const EdgeInsets.all(Sizing.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                ReviewPostCard(
                  post: widget.post,
                  isEmployee: widget.isEmployee,
                  otherUser: widget.otherUser,
                ),
                const CustomDivider(
                  padding: Sizing.formSpacing
                ),
                InputTitle(title: l10n.rating),
                const SizedBox(height: 2),
                Text(
                  l10n.ratingDesc,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  allowHalfRating: true,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  itemCount: 5,
                  itemSize: 32.0,
                  direction: Axis.horizontal,
                  onRatingUpdate: (rating) {
                    _rating = rating;
                  },
                ),
                const SizedBox(height: Sizing.inputSpacing),
                TextInput(
                  label: l10n.reviewTitle,
                  hint: l10n.reviewTitlePlaceholder,
                  maxLines: 1,
                ),
                const SizedBox(height: Sizing.inputSpacing),
                TextInput(
                  label: l10n.reviewDesc,
                  hint: l10n.reviewDescPlaceholder,
                  maxLines: 5,
                ),
                const SizedBox(height: Sizing.formSpacing),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom
                  ),
                  child: Button(
                    child: ButtonText(l10n.submitReview),
                    onPressed: () {
                      if (_rating == 0) {
                        SnackbarPresets.error(context, l10n.ratingRequired);
                        
                        return;
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
