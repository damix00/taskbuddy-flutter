import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/posts/post_response.dart';

class PostMedia extends StatelessWidget {
  final PostResponse post;
  final Function(int) onPageChanged;

  const PostMedia({ Key? key, required this.post, required this.onPageChanged }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 150),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 150,
            child: PageView.builder(
              itemCount: post.media.length,
              onPageChanged: (page) {
                onPageChanged(page);
              },
              itemBuilder: (context, index) {
                return Center(
                  child: CachedNetworkImage(
                    imageUrl: post.media[index],
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}