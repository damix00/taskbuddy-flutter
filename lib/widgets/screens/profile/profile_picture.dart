import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/widgets/input/pfp_input.dart';
import 'package:taskbuddy/widgets/overlays/loading_overlay.dart';
import 'package:taskbuddy/widgets/ui/feedback/snackbars.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/ui/visual/default_profile_picture.dart';

class _PFPDisplay extends StatelessWidget {
  final String profilePicture;

  const _PFPDisplay({required this.profilePicture, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (profilePicture.isEmpty) return const DefaultProfilePicture(size: 156);

    return ClipRRect(
      borderRadius: BorderRadius.circular(156),
      child: CachedNetworkImage(
        imageUrl: profilePicture,
        errorWidget: (context, url, error) => const DefaultProfilePicture(size: 156)
      ),
    );
  }
}

class _ProfilePFPInput extends StatefulWidget {
  final String profilePicture;

  const _ProfilePFPInput({required this.profilePicture, Key? key}) : super(key: key);

  @override
  State<_ProfilePFPInput> createState() => _ProfilePFPInputState();
}

class _ProfilePFPInputState extends State<_ProfilePFPInput> {
  bool _showChild = true;
  XFile? _image;

  void _onSelected(XFile? file) async {
    String? token = await AccountCache.getToken();

    if (token == null) return;

    if (file == null) {
      setState(() {
        _image = null;
        _showChild = false;
      });

      LoadingOverlay.showLoader(context);

      var result = await Api.v1.accounts.meRoute.profile.update(
        token,
        removeProfilePicture: true
      );

      if (result.response!.statusCode != 200) {
        SnackbarPresets.error(context, AppLocalizations.of(context)!.somethingWentWrong);
      }

      else {
        SnackbarPresets.show(context, text: AppLocalizations.of(context)!.successfullyChangedPfp);
        AccountCache.setProfilePicture(result.data!.profilePicture);
      }

      Navigator.of(context).pop(); // hide overlay

      return;
    }

    else {
      setState(() {
        _image = XFile(file.path);
        _showChild = false;
      });

      LoadingOverlay.showLoader(context);

      var result = await Api.v1.accounts.meRoute.profile.update(
        token,
        profilePicture: File(file.path),
      );

      if (result.response!.statusCode != 200) {
        SnackbarPresets.error(context, AppLocalizations.of(context)!.somethingWentWrong);
      }

      else {
        SnackbarPresets.show(context, text: AppLocalizations.of(context)!.successfullyChangedPfp);
        AccountCache.setProfilePicture(result.data!.profilePicture);
      }

      Navigator.of(context).pop(); // hide the loading overlay
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProfilePictureInput(
      onSelected: _onSelected,
      showTitle: false,
      width: 156,
      height: 156,
      iconSize: 24,
      iconBackgroundSize: 48,
      centered: true,
      image: _image,
      child: (_showChild && widget.profilePicture.isNotEmpty) ? _PFPDisplay(profilePicture: widget.profilePicture) : null,
    );
  }
}

class ProfilePFP extends StatelessWidget {
  final bool isMe;
  final String profilePicture;

  const ProfilePFP({this.isMe = false, required this.profilePicture, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isMe ? _ProfilePFPInput(profilePicture: profilePicture,) : SizedBox(
      height: 156,
      width: 156,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(156),
            child: _PFPDisplay(profilePicture: profilePicture),
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
    );
  }
}