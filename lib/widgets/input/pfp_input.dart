import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/input/input_title.dart';
import 'package:taskbuddy/widgets/input/touchable/touchable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskbuddy/widgets/ui/cross_platform_bottom_sheet.dart';

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
    AppLocalizations l10n = AppLocalizations.of(context)!;

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
              var items = [
                BottomSheetButton(
                  title: l10n.takePhoto,
                  icon: Icons.camera_alt,
                  onTap: (ctx) {
                    Navigator.of(ctx).pop(); // Close the bottom sheet
                    // Take a photo
                    ImagePicker().pickImage(source: ImageSource.camera).then((value) {
                      widget.onSelected!(value);
                    });
                  }
                ),
                BottomSheetButton(
                  title: l10n.chooseFromGallery,
                  icon: Icons.photo_library,
                  onTap: (ctx) {
                    Navigator.of(ctx).pop(); // Close the bottom sheet
                    // Choose from gallery
                    ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
                      widget.onSelected!(value);
                    });
                  }
                ),
              ];

              if (widget.image != null) {
                items.add(BottomSheetButton(
                  title: l10n.remove,
                  icon: Icons.delete,
                  onTap: (ctx) {
                    Navigator.of(ctx).pop(); // Close the bottom sheet
                    widget.onSelected!(null);
                  }
                ));
              }

              // Show a bottom sheet to choose an action
              CrossPlatformBottomSheet.showModal(
                context,
                items
              );
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
