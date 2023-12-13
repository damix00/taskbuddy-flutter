import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/posts/post_response.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class PostPrice extends StatelessWidget {
  final PostResponse post;

  const PostPrice({ Key? key, required this.post }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
      child: Text(
        '€${post.price}',
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}