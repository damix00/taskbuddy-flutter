import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/input/touchable/touchable.dart';
import 'package:taskbuddy/widgets/ui/default_profile_picture.dart';

class ProfilePFP extends StatelessWidget {
  final bool isMe;
  final String profilePicture;

  const ProfilePFP({this.isMe = false, required this.profilePicture, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PFPParent(
      isMe: isMe,
      onPressed: () {
        
      },
      child: SizedBox(
        height: 156,
        width: 156,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(156),
              child: CachedNetworkImage(
                  imageUrl: profilePicture,
                  errorWidget: (context, url, error) =>
                      const DefaultProfilePicture(size: 156)),
            ),
            if (isMe)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(56),
                  ),
                  width: 48,
                  height: 48,
                  child: Icon(Icons.edit, size: 24, color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PFPParent extends StatelessWidget {
  final bool isMe;
  final Widget child;
  final VoidCallback? onPressed;

  const _PFPParent({this.onPressed, required this.child, required this.isMe, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isMe
      ? Touchable(
        onTap: onPressed,
        child: child
      )
      : child;
  }
}
