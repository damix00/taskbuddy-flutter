import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:taskbuddy/widgets/input/input_title.dart';
import 'package:taskbuddy/widgets/input/touchable/touchable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskbuddy/widgets/ui/platforms/bottom_sheet.dart';
import 'package:taskbuddy/widgets/ui/visual/default_profile_picture.dart';

// A button that allows the user to select a profile picture
class ProfilePictureInput extends StatefulWidget {
  final XFile? image;
  final Widget? child;
  final bool optional;
  final void Function(XFile?)? onSelected;
  final String? title;
  final bool showTitle;
  final bool showIcon;
  final double width;
  final double height;
  final double iconSize;
  final double pfpIconSize;
  final double iconBackgroundSize;
  final bool centered;

  const ProfilePictureInput({
    required this.onSelected,
    this.child,
    this.optional = true,
    this.image,
    this.title,
    this.showIcon = true,
    this.showTitle = true,
    this.width = 60,
    this.height = 60,
    this.iconSize = 14,
    this.iconBackgroundSize = 20,
    this.pfpIconSize = 32,
    this.centered = false,
    Key? key})
      : super(key: key);

  @override
  _ProfilePictureInputState createState() => _ProfilePictureInputState();
}

class _ProfilePictureInputState extends State<ProfilePictureInput> {
  void onSelected(XFile? image) async {
    if (image == null) {
      widget.onSelected!(null);
      return;
    }

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      compressQuality: 100,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: AppLocalizations.of(context)!.cropImage,
          backgroundColor: Theme.of(context).colorScheme.background,
          toolbarColor: Theme.of(context).colorScheme.surface,
          toolbarWidgetColor: Theme.of(context).colorScheme.onSurface,
          activeControlsWidgetColor: Theme.of(context).colorScheme.primary,
          hideBottomControls: true
        ),
        IOSUiSettings(
          title: AppLocalizations.of(context)!.cropImage,
          cancelButtonTitle: AppLocalizations.of(context)!.cancel,
          doneButtonTitle: AppLocalizations.of(context)!.done,
        )
      ]
    );

    if (croppedFile != null) {
      widget.onSelected!(XFile(croppedFile.path));
    }

  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity, // make the width the same as the parent so it isn't centered
      child: Column(
        crossAxisAlignment: widget.centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          if (widget.showTitle) InputTitle(
            title: widget.title ?? AppLocalizations.of(context)!.profilePicture,
            optional: widget.optional,
          ),
          if (widget.showTitle) const SizedBox(height: 8),
          // Show the profile picture
          Touchable(
            onTap: () async {
              // Buttons to take a photo, choose from gallery and remove the profile picture
              var items = [
                BottomSheetButton(
                  title: l10n.takePhoto,
                  icon: Icons.camera_alt,
                  onTap: (ctx) async {
                    // Take a photo
                    var value = await ImagePicker().pickImage(source: ImageSource.camera);
                    if (value != null) onSelected(value);
                  }
                ),
                BottomSheetButton(
                  title: l10n.chooseFromGallery,
                  icon: Icons.photo_library,
                  onTap: (ctx) async {
                    // Choose from gallery
                    var value = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (value != null) onSelected(value);
                  }
                ),
              ];

              if (widget.image != null || widget.child != null) {
                items.add(BottomSheetButton(
                  title: l10n.remove,
                  icon: Icons.delete,
                  onTap: (ctx) {
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
            // Show the profile picture or a placeholder
            child: Stack(
              children: [
                Container(
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: _PfpInputImage(
                    width: widget.width,
                    height: widget.height,
                    image: widget.image,
                    iconSize: widget.pfpIconSize,
                    child: widget.child,
                  ),
                ),
                if (widget.showIcon)
                  // Show the plus icon if the user can add a profile picture
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: widget.iconBackgroundSize,
                      height: widget.iconBackgroundSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Icon(Icons.edit, size: widget.iconSize, color: Theme.of(context).colorScheme.onPrimary),
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

class _PfpInputImage extends StatelessWidget {
  final XFile? image;
  final Widget? child;
  final double width;
  final double height;
  final double? iconSize;

  const _PfpInputImage({required this.width, required this.height, this.iconSize, this.image, this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(height),
        child: Image.file(
          File(image!.path),
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      );
    }

    if (child != null) {
      return child!;
    }

    return DefaultProfilePicture(size: width, iconSize: iconSize,);
  }
}