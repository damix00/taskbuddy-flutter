import 'dart:io';

import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/input/input_title.dart';
import 'package:taskbuddy/widgets/input/touchable/touchable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureInput extends StatefulWidget {
  final XFile? image;
  final bool optional;
  final void Function(XFile?)? onSelected;
  final String? title;
  final bool showPlus;

  const ProfilePictureInput({
    required this.onSelected,
    this.optional = true,
    this.image,
    this.title,
    this.showPlus = true,
    Key? key})
      : super(key: key);

  @override
  _ProfilePictureInputState createState() => _ProfilePictureInputState();
}

class _ProfilePictureInputState extends State<ProfilePictureInput> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // make the width the same as the parent so it isn't centered
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputTitle(
            title: widget.title ?? AppLocalizations.of(context)!.profilePicture,
            optional: widget.optional,
          ),
          const SizedBox(height: 8),
          Touchable(
            onTap: () async {
              final ImagePicker picker = ImagePicker();

              // Choose a photo from the gallery
              final XFile? photo = await picker.pickImage(source: ImageSource.gallery);

              if (photo != null) {
                // If the user selected a photo, call the onSelected callback
                widget.onSelected?.call(photo);
              }
            },
            child: Stack(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: widget.image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.file(
                          File(widget.image!.path),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.person, size: 30,),
                ),
                if (widget.showPlus)
                  // Show the plus icon if the user can add a profile picture
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Icon(Icons.add, size: 14, color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
              ],
            )
          ),
        ],
      ),
    );
  }
}
