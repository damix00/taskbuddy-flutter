import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/screens/home/pages/profile/edit/edit_form.dart';
import 'package:taskbuddy/widgets/input/with_state/location_display.dart';
import 'package:taskbuddy/state/providers/auth.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/overlays/dialog/dialog.dart';
import 'package:taskbuddy/widgets/overlays/loading_overlay.dart';
import 'package:taskbuddy/widgets/ui/feedback/snackbars.dart';
import 'package:taskbuddy/widgets/ui/platforms/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _madeChanges = false;
  XFile? _pfp;
  bool _changedPfp = false;
  String _firstName = '';
  String _lastName = '';
  String _username = '';
  String _bio = '';
  LatLng? _location;
  String? _locationName;
  bool _init = false;

  @override
  void initState() {
    super.initState();
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      String? token = await AccountCache.getToken();

      if (token == null) {
        return;
      }

      LoadingOverlay.showLoader(context);

      var result = await Api.v1.accounts.meRoute.profile.update(
        token,
        firstName: _firstName,
        lastName: _lastName,
        username: _username,
        profilePicture: _pfp != null ? File(_pfp!.path) : null,
        removeProfilePicture: _changedPfp && _pfp == null,
        lat: _location?.latitude,
        lon: _location?.longitude,
        locationText: _locationName,
        bio: _bio,
      );

      LoadingOverlay.hideLoader(context);

      if (result.status == 200) {
        SnackbarPresets.show(context, text: AppLocalizations.of(context)!.successfullyChanged);

        Provider.of<AuthModel>(context, listen: false).setAccountResponse(result.data!);
        AccountCache.saveAccountResponse(result.data!);

        Navigator.of(context).pop();
      }

      else {
        SnackbarPresets.show(context, text: AppLocalizations.of(context)!.somethingWentWrong);
      }
    }
  }

  void _handleBackBtn(AppLocalizations l10n) {
    if (_madeChanges) {
      CustomDialog.show(
        context,
        title: l10n.popupEditProfileCancelTitle,
        description: l10n.popupEditProfileCancelDesc,
        actions: [
          DialogAction(
            text: l10n.cancel,
            onPressed: () {
              Navigator.of(context).pop();
            }
          ),
          DialogAction(
            text: l10n.discard,
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }
          ),
        ]
      );
    }
    else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return WillPopScope(
      onWillPop: () async {
        _handleBackBtn(l10n);
        return false;
      },
      child: Scaffold(
        appBar: BlurAppbar.appBar(
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close, size: 24),
                onPressed: () async {
                  _handleBackBtn(l10n);
                }
              ),
              Text(
                AppLocalizations.of(context)!.editProfile,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Spacer(),
              IconButton(
                color: _madeChanges ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
                icon: const Icon(Icons.check, size: 24),
                onPressed: _madeChanges ? _handleSubmit : null,
              ),
            ],
          ),
          showLeading: false,
        ),
        extendBodyBehindAppBar: true,
        body: ScrollbarSingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + Sizing.appbarHeight),
              Consumer<AuthModel>(
                builder: (context, value, child) {
                  if (!_init) {
                    _init = true;
                    _location = (value.lat != null && value.lon != null && value.lat != 1000 && value.lon != 1000) ? LatLng(value.lat!.toDouble(), value.lon!.toDouble()) : null;
                    _locationName = value.locationText;
                    _bio = value.bio;
                    _username = value.username;
                    _lastName = value.lastName;
                    _firstName = value.firstName;
                  }

                  return ProfileEditForm(
                    formKey: _formKey,
                    profilePicture: value.profilePicture,
                    firstName: value.firstName,
                    lastName: value.lastName,
                    username: value.username,
                    bio: value.bio,
                    latitude: value.lat == 1000 ? null : value.lat?.toDouble(),
                    longitude: value.lon == 1000 ? null : value.lon?.toDouble(),
                    locationName: value.locationText,
                    onProfilePictureSelected: (XFile? file) {
                      setState(() {
                        _madeChanges = true;
                        _pfp = file;
                        _changedPfp = true;
                      });
                    },
                    onChangeMade: (String? value) {
                      // Set state if it hasn't been set yet
                      // This is for performance reasons
                      if (!_madeChanges) {
                        setState(() {
                          _madeChanges = true; 
                        });
                      }
                    },
                    onLocationChanged: (LocationData? data) {
                      if (data == null) {
                        setState(() {
                          _location = null;
                          _locationName = null;
                        });
                      }
                      else {
                        setState(() {
                          _location = data.location;
                          _locationName = data.locationName;
                        });
                      }
                    },
                    onFirstNameChanged: (String value) {
                      _firstName = value;
                    },
                    onLastNameChanged: (String value) {
                      _lastName = value;
                    },
                    onUsernameChanged: (String value) {
                      _username = value;
                    },
                    onBioChanged: (String value) {
                      _bio = value;
                    },
                  );
                }
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ],
          ),
        )
      ),
    );
  }
}
