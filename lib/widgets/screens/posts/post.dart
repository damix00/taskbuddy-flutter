import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/posts/post_response.dart';
import 'package:taskbuddy/widgets/screens/posts/post_media.dart';
import 'package:taskbuddy/widgets/screens/posts/post_tags.dart';

class PostLayout extends StatelessWidget {
  final PostResponse post;

  const PostLayout({ Key? key, required this.post }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PostMedia(post: post),
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom,
          child: Column(
            children: [
              PostTags(post: post),
            ],
          )
        ),
      ],
    );
  }
}