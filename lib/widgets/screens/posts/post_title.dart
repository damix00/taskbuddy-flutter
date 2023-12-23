import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:taskbuddy/api/responses/posts/post_results_response.dart';

class PostTitle extends StatelessWidget {
  final PostResultsResponse post;

  const PostTitle({ Key? key, required this.post }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
        child: Text(
          post.title,
          style: Theme.of(context).textTheme.bodyLarge,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}