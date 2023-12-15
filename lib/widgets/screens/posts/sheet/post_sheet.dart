import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/posts/post_response.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/slim_button.dart';
import 'package:taskbuddy/widgets/screens/posts/post_description.dart';
import 'package:taskbuddy/widgets/screens/posts/post_price.dart';
import 'package:taskbuddy/widgets/screens/posts/post_title.dart';
import 'package:taskbuddy/widgets/screens/posts/sheet/post_counter.dart';
import 'package:taskbuddy/widgets/screens/posts/sheet/post_job_type.dart';
import 'package:taskbuddy/widgets/screens/posts/sheet/post_metadata.dart';
import 'package:taskbuddy/widgets/ui/platforms/bottom_sheet.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:taskbuddy/widgets/ui/visual/divider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostSheet extends StatelessWidget {
  final PostResponse post;
  final double paddingBottom;

  const PostSheet({ Key? key, required this.post, required this.paddingBottom }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return BottomSheetBase(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        PostJobType(post: post),
        const SizedBox(height: 8),
        PostTitle(post: post),
        const SizedBox(height: 2),
        PostDescription(post: post),
        const SizedBox(height: 4),
        PostPrice(post: post),
        const SizedBox(height: 8),
        PostData(post: post),
        const SizedBox(height: 16),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizing.horizontalPadding,
            ),
            child: SlimButton(
              type: ButtonType.outlined,
              child: Center(
                child: Text(
                  l10n.sendAMessage,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface)
                )
              ),
              onPressed: () {},
            ),
          ),
        ),
        const SizedBox(height: 8),
        CustomDivider(color: Theme.of(context).colorScheme.outline),
        const SizedBox(height: 8),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.spaceEvenly,
            children: [
              PostCounter(count: 10000, text: 'test'),
              PostCounter(count: post.likes, text: 'test'),
              PostCounter(count: post.shares, text: 'test'),
            ],
          ),
        ),
        SizedBox(height: paddingBottom),
      ],
    );
  }
}
