import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/posts/post_only_response.dart';
import 'package:taskbuddy/api/responses/posts/post_results_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/screens/chat/chat_screen.dart';
import 'package:taskbuddy/state/providers/messages.dart';
import 'package:taskbuddy/utils/haptic_feedback.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/slim_button.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/overlays/dialog/dialog.dart';
import 'package:taskbuddy/widgets/overlays/dialog/report_dialog.dart';
import 'package:taskbuddy/widgets/overlays/loading_overlay.dart';
import 'package:taskbuddy/widgets/screens/compose_message/compose_message.dart';
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
  final PostResultsResponse post;

  const PostLayout({ Key? key, required this.post }) : super(key: key);

  @override
  State<PostLayout> createState() => _PostLayoutState();
}

class _PostLayoutState extends State<PostLayout> {
  int _page = 0;

  late PostResultsResponse _post;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
  }

  void _openOptionsMenu() async {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    String token = (await AccountCache.getToken())!;

    List<BottomSheetButton> buttons = [
      BottomSheetButton(
        title: l10n.report,
        icon: Icons.flag_outlined,
        onTap: (c) {
          showDialog(
            useSafeArea: false,
            context: context,
            builder: (ctx) => Dialog(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: ReportDialog(
                  UUID: _post.UUID,
                  type: ReportType.post,
                )
              )
            )
          );
        },
      ),
    ];

    if (_post.user.isMe) {
      buttons.add(BottomSheetButton(
        title: l10n.deleteText,
        icon: Icons.delete_outline,
        onTap: (c) async {
          try {
            // Show yes/no dialog
            CustomDialog.show(
              context,
              title: l10n.deletePost,
              description: l10n.deletePostDesc,
              actions: [
                DialogAction(
                  text: l10n.cancel,
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
                ),
                DialogAction(
                  text: l10n.deleteText,
                  onPressed: () async {
                    LoadingOverlay.showLoader(context);

                    var res = await Api.v1.posts.deletePost(token, _post.UUID);

                    LoadingOverlay.hideLoader(context);
                    
                    if (res) {
                      SnackbarPresets.show(context, text: l10n.successfullyDeleted);
                    }
                    else {
                      SnackbarPresets.show(context, text: l10n.somethingWentWrong);
                    }
                    
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }
                ),
              ]
            );
          } catch (e) {
            SnackbarPresets.show(context, text: l10n.somethingWentWrong);
            dev.log(e.toString());
          }
        },
      ));

      buttons.add(
        BottomSheetButton(
          title: _post.isReserved ? l10n.unreserve : l10n.reserve,
          icon: _post.isReserved ? Icons.remove_done : Icons.done_all,
          onTap: (c) {
            CustomDialog.show(
              context,
              title: _post.isReserved ? l10n.unreserve : l10n.reserve,
              description: _post.isReserved ? l10n.unreserveDesc : l10n.reserveDesc,
              actions: [
                DialogAction(
                  text: l10n.cancel,
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
                ),
                DialogAction(
                  text: _post.isReserved ? l10n.unreserve : l10n.reserve,
                  onPressed: () async {
                    bool res = false;

                    LoadingOverlay.showLoader(context);

                    if (_post.isReserved) {
                      res = await Api.v1.posts.unreservePost(token, _post.UUID);
                    }
                    else {
                      res = await Api.v1.posts.reservePost(token, _post.UUID);
                    }

                    LoadingOverlay.hideLoader(context);

                    if (res) {
                      SnackbarPresets.show(context, text: l10n.success);
                    }
                    else {
                      SnackbarPresets.show(context, text: l10n.somethingWentWrong);
                    }

                    setState(() {
                      _post.isReserved = !_post.isReserved;
                      widget.post.isReserved = !_post.isReserved;
                    });
                    
                    Navigator.of(context).pop();
                  }
                ),
              ]
            );
          },
        )
      );
    }

    CrossPlatformBottomSheet.showModal(
      context,
      buttons
    );
  }

  Future<void> _onLiked() async {
    int likes = _post.likes;
    bool isLiked = _post.isLiked;

    setState(() {
      _post.likes += _post.isLiked ? -1 : 1;

      _post.isLiked = !_post.isLiked;
    });

    String token = (await AccountCache.getToken())!;

    try {
      bool res = false;

      if (isLiked) {
        res = await Api.v1.posts.interactions.unlikePost(token, _post.UUID);
      }
      else {
        res = await Api.v1.posts.interactions.likePost(token, _post.UUID);
      }
      
      if (!res) {
        SnackbarPresets.show(context, text: AppLocalizations.of(context)!.somethingWentWrong);

        setState(() {
          _post.likes = likes;
          _post.isLiked = isLiked;
        });
      }

    }
    catch (e) {
      dev.log(e.toString());
    }
  }

  Future<void> _onBookmarked() async {
    int bookmarks = _post.bookmarks;
    bool isBookmarked = _post.isBookmarked;

    setState(() {
      _post.bookmarks += _post.isBookmarked ? -1 : 1;

      _post.isBookmarked = !_post.isBookmarked;
    });

    String token = (await AccountCache.getToken())!;

    try {
      bool res = false;

      if (isBookmarked) {
        res = await Api.v1.posts.interactions.unbookmarkPost(token, _post.UUID);
      }
      else {
        res = await Api.v1.posts.interactions.bookmarkPost(token, _post.UUID);
      }
      
      if (!res) {
        SnackbarPresets.show(context, text: AppLocalizations.of(context)!.somethingWentWrong);

        setState(() {
          _post.bookmarks = bookmarks;
          _post.isBookmarked = isBookmarked;
        });
      }

    }
    catch (e) {
      dev.log(e.toString());
    }
  }

  void _sendMessage() {
    MessagesModel model = Provider.of<MessagesModel>(context, listen: false);

    var channel = model.hasPost(_post.UUID);

    if (channel != null) {
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => ChatScreen(
            channel: channel
          ),
        ),
      );

      return;
    }

    double h = min(MediaQuery.of(context).size.height * 0.4, 400);

    // Show a bottom sheet
    showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
        minHeight: 0,
      ),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) => ComposeMessageSheet(
        post: _post,
        height: h
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    // Stack
    // On the bottom, the post media (images, videos, etc)
    // On the top, the post information (title, description, etc)
    // On the top of the post information, the post interactions (like, bookmark, etc)
    return Stack(
      children: [
        GestureDetector(
          onLongPress: _openOptionsMenu,
          // When the screen is double tapped, like the post
          onDoubleTap: () {
            HapticFeedbackUtils.mediumImpact(context);
            if (_post.isLiked) {
              return;
            }
            
            _onLiked();
          },
          // Media
          child: PostMedia(
            post: widget.post,
            onPageChanged: (page) {
              setState(() {
                _page = page;
              });
            },
          ),
        ),
        // Post information
        Stack(
          children: [
            // A gradient so it's easier to read the post information
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.inverseSurface.withOpacity(0),
                      Theme.of(context).colorScheme.inverseSurface.withOpacity(1),
                    ]
                  )
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page indicator (dots)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: Sizing.horizontalPadding),
                    child: PageViewDotIndicator(
                      currentItem: _page,
                      count: widget.post.media.length,
                      unselectedColor: Theme.of(context).colorScheme.surface,
                      selectedColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  // Post tags (categories)
                  PostTags(post: _post),
                  const SizedBox(height: 12),
                  // Post author (user)
                  PostAuthor(post: _post),
                  const SizedBox(height: 8),
                  // Post price
                  PostPrice(post: _post),
                  const SizedBox(height: 4),
                  // Post title
                  PostTitle(post: _post),
                  const SizedBox(height: 2),
                  // Post description
                  PostDescription(post: _post),
                  const SizedBox(height: 8),
                  // Tap to read more button (opens a bottom sheet)
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
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          context: context,
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.4
                          ),
                          builder: (ctx) => PostSheet(
                            post: widget.post,
                            paddingBottom: MediaQuery.of(context).padding.bottom,
                            sendMessage: _sendMessage,
                          )
                        );
                      },
                    ),
                  ),
                  if (!_post.user.isMe)
                    const SizedBox(height: 12),

                  if (!_post.user.isMe)
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(left: Sizing.horizontalPadding, right: Sizing.horizontalPadding + Sizing.interactionsWidth),
                        child: SlimButton(
                          disabled: _post.endDate.isBefore(DateTime.now()) || _post.status == PostStatus.RESERVED || _post.status == PostStatus.CLOSED,
                          onPressed: _sendMessage,
                          type: ButtonType.outlined,
                          child: Text(
                            l10n.sendAMessage,
                              style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontSize: 12
                            )
                          ),
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: Sizing.horizontalPadding),
                ],
              )
            ),
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + Sizing.horizontalPadding,
              right: 0,
              child: PostInteractions(
                post: _post,
                onLiked: _onLiked,
                onBookmarked: _onBookmarked,
                onMore: _openOptionsMenu
              )
            ),
          ],
        ),
      ],
    );
  }
}