import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/posts/post_results_response.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class PostInteractionButton extends StatelessWidget {
  final IconData icon;
  final IconData? activeIcon;
  final String? text;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;

  const PostInteractionButton({
    Key? key,
    required this.icon,
    required this.onTap,
    this.text,
    this.isActive = false,
    this.activeIcon,
    this.activeColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Touchable(
      onTap: onTap,
      child: Column(
        children: [
          isActive ? Icon(activeIcon!, size: 28, color: activeColor) : Icon(icon, size: 28, color: Theme.of(context).colorScheme.onBackground),
          if (text != null) Text(text!),
        ],
      ),
    );
  }
}

class PostInteractions extends StatelessWidget {
  final PostResultsResponse post;
  final VoidCallback? onLiked;
  final VoidCallback? onBookmarked;

  const PostInteractions({ Key? key, required this.post, this.onLiked, this.onBookmarked }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double spacing = 16;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Colors.transparent, Colors.black.withOpacity(0.1)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding).copyWith(top: 16),
        child: Column(
          children: [
            PostInteractionButton(
              icon: Icons.favorite_border,
              activeIcon: Icons.favorite,
              activeColor: Colors.red,
              text: post.likes.toString(),
              isActive: post.isLiked,
              onTap: () {
                onLiked?.call();
              },
            ),
    
            SizedBox(
              height: spacing,
            ),
    
            PostInteractionButton(
              icon: Icons.comment_outlined,
              text: post.comments.toString(),
              onTap: () {},
            ),
    
            SizedBox(
              height: spacing,
            ),
    
            PostInteractionButton(
              icon: Icons.bookmark_outline,
              activeIcon: Icons.bookmark,
              text: post.bookmarks.toString(),
              isActive: post.isBookmarked,
              onTap: () {
                onBookmarked?.call();
              },
            ),
    
            SizedBox(
              height: spacing,
            ),
    
            PostInteractionButton(
              icon: Icons.share_outlined,
              text: post.shares.toString(),
              onTap: () {},
            ),
    
            SizedBox(
              height: spacing,
            ),
    
            PostInteractionButton(
              icon: Icons.more_vert,
              onTap: () {},
            ),

            const SizedBox(
              height: 4
            ),
          ],
        ),
      ),
    );
  }
}