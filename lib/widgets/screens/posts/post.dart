import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/posts/post_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/utils/haptic_feedback.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/slim_button.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/screens/posts/post_description.dart';
import 'package:taskbuddy/widgets/screens/posts/post_price.dart';
import 'package:taskbuddy/widgets/screens/posts/sheet/post_sheet.dart';
import 'package:taskbuddy/widgets/ui/feedback/snackbars.dart';
import 'package:taskbuddy/widgets/ui/platforms/bottom_sheet.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:taskbuddy/widgets/screens/posts/post_author.dart';
import 'package:taskbuddy/widgets/screens/posts/post_interactions.dart';
import 'package:taskbuddy/widgets/screens/posts/post_media.dart';
import 'package:taskbuddy/widgets/screens/posts/post_tags.dart';
import 'package:taskbuddy/widgets/screens/posts/post_title.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostLayout extends StatefulWidget {
  final PostResponse post;

  const PostLayout({ Key? key, required this.post }) : super(key: key);

  @override
  State<PostLayout> createState() => _PostLayoutState();
}

class _PostLayoutState extends State<PostLayout> {
  int _page = 0;

  late PostResponse _post;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
  }

  void _openOptionsMenu() async {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    String token = (await AccountCache.getToken())!;

    List<BottomSheetButton> buttons = [];

    if (_post.user.isMe) {
      buttons.add(BottomSheetButton(
        title: l10n.deleteText,
        icon: Icons.delete_outline,
        onTap: (c) async {
          try {
            var res = await Api.v1.posts.deletePost(token, _post.UUID);
            if (res) {
              SnackbarPresets.show(context, text: l10n.successfullyDeleted);
              Navigator.of(context).pop();
            }
            else {
              SnackbarPresets.show(context, text: l10n.somethingWentWrong);
            }
          } catch (e) {
            SnackbarPresets.show(context, text: l10n.somethingWentWrong);
            log(e.toString());
          }
        },
      ));
    }

    CrossPlatformBottomSheet.showModal(
      context,
      buttons
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Stack(
      children: [
        GestureDetector(
          onLongPress: _openOptionsMenu,
          onDoubleTap: () {
            HapticFeedbackUtils.mediumImpact(context);
            setState(() {
              _post.isLiked = !_post.isLiked;
            });
          },
          child: PostMedia(
            post: widget.post,
            onPageChanged: (page) {
              setState(() {
                _page = page;
              });
            },
          ),
        ),
        Stack(
          children: [
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: Sizing.horizontalPadding),
                    child: PageViewDotIndicator(
                      currentItem: _page,
                      count: widget.post.media.length,
                      unselectedColor: Theme.of(context).colorScheme.surface,
                      selectedColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  PostTags(post: _post),
                  const SizedBox(height: 12),
                  Touchable(
                    child: PostAuthor(post: _post),
                    onTap: () {
                      if (widget.post.user.isMe) {
                        // TODO: add profile screen
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  // PostJobType(post: _post),
                  PostPrice(post: _post),
                  const SizedBox(height: 4),
                  PostTitle(post: _post),
                  const SizedBox(height: 2),
                  PostDescription(post: _post),
                  const SizedBox(height: 4),
                  // const SizedBox(height: 4),
                  // PostData(post: _post),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
                    child: Touchable(
                      child: Text(
                        l10n.tapToReadMore,
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          enableDrag: true,
                          context: context,
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.4
                          ),
                          builder: (ctx) => PostSheet(
                            post: widget.post,
                            paddingBottom: MediaQuery.of(context).padding.bottom,
                          )
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(left: Sizing.horizontalPadding, right: Sizing.horizontalPadding + Sizing.interactionsWidth),
                      child: SlimButton(
                        child: Text(l10n.sendAMessage, style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 12
                        )),
                        onPressed: () {},
                        type: ButtonType.outlined,
                      ),
                    ),
                  )
                ],
              )
            ),
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom,
              right: 0,
              child: PostInteractions(post: _post)
            ),
          ],
        ),
      ],
    );
  }
}