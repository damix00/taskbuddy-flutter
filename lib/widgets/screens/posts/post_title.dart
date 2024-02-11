import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:taskbuddy/api/responses/posts/post_results_response.dart';

class PostTitle extends StatelessWidget {
  final PostResultsResponse post;
  final bool limitLines;

  const PostTitle({ Key? key, required this.post, this.limitLines = true }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(left: Sizing.horizontalPadding, right: Sizing.horizontalPadding + (limitLines ? Sizing.interactionsWidth : 0)),
        child: Text(
          post.title,
          style: Theme.of(context).textTheme.bodyLarge,
          maxLines: limitLines ? 1 : null,
          overflow: limitLines ? TextOverflow.ellipsis : null,
        ),
      ),
    );
  }
}
