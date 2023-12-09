import 'dart:math';

import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:taskbuddy/api/responses/posts/post_response.dart';

class PostMedia extends StatefulWidget {
  final PostResponse post;

  const PostMedia({ Key? key, required this.post }) : super(key: key);

  @override
  State<PostMedia> createState() => _PostMediaState();
}

class _PostMediaState extends State<PostMedia> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
          child: PageView.builder(
            itemCount: widget.post.media.length,
            onPageChanged: (page) {
              setState(() {
                _page = page;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                widget.post.media[index],
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              );
            },
          ),
        ),
        PageViewDotIndicator(
          currentItem: _page,
          count: widget.post.media.length,
          unselectedColor: Theme.of(context).colorScheme.surface,
          selectedColor: Theme.of(context).colorScheme.primary,
        )
      ],
    );
  }
}