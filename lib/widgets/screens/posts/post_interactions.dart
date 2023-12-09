import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/posts/post_response.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class PostInteractionButton extends StatelessWidget {
  final IconData icon;
  final IconData? activeIcon;
  final String? text;
  final bool isActive;
  final VoidCallback onTap;

  const PostInteractionButton({
    Key? key,
    required this.icon,
    required this.onTap,
    this.text,
    this.isActive = false,
    this.activeIcon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Touchable(
      onTap: onTap,
      child: Column(
        children: [
          isActive ? Icon(activeIcon!, size: 28) : Icon(icon, size: 28),
          if (text != null) Text(text!),
        ],
      ),
    );
  }
}

class PostInteractions extends StatelessWidget {
  final PostResponse post;

  const PostInteractions({ Key? key, required this.post }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double spacing = 16;
    double iconSize = 28;

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
              text: post.likes.toString(),
              isActive: post.isLiked,
              onTap: () {},
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
              onTap: () {},
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
          ],
        ),
      ),
    );
  }
}