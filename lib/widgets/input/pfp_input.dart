import 'dart:io';

import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/input/touchable/touchable.dart';

class ProfilePictureInput extends StatefulWidget {
  final File? image;
  final void Function(File?)? onSelected;

  const ProfilePictureInput({required this.onSelected, this.image, Key? key}) : super(key: key);

  @override
  _ProfilePictureInputState createState() => _ProfilePictureInputState();
}

class _ProfilePictureInputState extends State<ProfilePictureInput> {
  @override
  Widget build(BuildContext context) {
    return Touchable(
      onTap: () {},
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: widget.image != null
                ? FileImage(widget.image!)
                : AssetImage('assets/images/default_profile_picture.png') as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
      )
    );
  }
}
