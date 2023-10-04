import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileLayout extends StatelessWidget {
  final String profilePicture;
  final List<Widget> actions;

  const ProfileLayout(
      {required this.profilePicture, required this.actions, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(profilePicture);

    return Column(
      children: [
        CachedNetworkImage(
          imageUrl: profilePicture,
        )
      ],
    );
  }
}
