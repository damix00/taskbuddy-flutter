import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:taskbuddy/api/responses/posts/post_response.dart';
import 'package:taskbuddy/widgets/screens/posts/post_author.dart';
import 'package:taskbuddy/widgets/screens/posts/post_interactions.dart';
import 'package:taskbuddy/widgets/screens/posts/post_job_type.dart';
import 'package:taskbuddy/widgets/screens/posts/post_media.dart';
import 'package:taskbuddy/widgets/screens/posts/post_tags.dart';
import 'package:taskbuddy/widgets/screens/posts/post_title.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onDoubleTap: () {
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
                  PostAuthor(post: _post),
                  const SizedBox(height: 8),
                  PostJobType(post: _post),
                  const SizedBox(height: 2),
                  PostTitle(post: _post),
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