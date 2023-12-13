import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/posts/post_response.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class PostCard extends StatelessWidget {
  final PostResponse post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizing.horizontalPadding),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                imageUrl: post.media[0],
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: Theme.of(context).textTheme.titleSmall
                ),
                const SizedBox(height: 4),
                Text(
                  post.description.replaceAll("\n", " "),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}