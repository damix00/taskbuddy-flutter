import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/screens/home/pages/profile/edit/location_display.dart';
import 'package:taskbuddy/state/providers/auth.dart';
import 'package:taskbuddy/widgets/input/pfp_input.dart';
import 'package:taskbuddy/widgets/input/text_input.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/overlays/dialog/dialog.dart';
import 'package:taskbuddy/widgets/ui/platforms/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class _ProfileEditForm extends StatefulWidget {
  final String profilePicture;
  final String firstName;
  final String lastName;
  final String username;
  final String bio;
  final double latitude;
  final double longitude;
  final String locationName;
  final Function(XFile?) onProfilePictureSelected;
  final Function(String?) onChangeMade;

  final formKey;

  const _ProfileEditForm({
    required this.profilePicture,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.formKey,
    required this.onProfilePictureSelected,
    required this.onChangeMade,
    this.locationName = '',
    this.latitude = 1000,
    this.longitude = 1000,
    this.bio = '',
    Key? key
  }) : super(key: key);

  @override
  __ProfileEditFormState createState() => __ProfileEditFormState();
}

class __ProfileEditFormState extends State<_ProfileEditForm> {
  final MapController _mapController = MapController();

  bool _showChild = true;
  XFile? _image;
  double _lat = 1000;
  double _lon = 1000;

  void _onSelected(XFile? file) async {
    setState(() {
      _image = file;
      _showChild = false;
    });

    widget.onProfilePictureSelected(file);
  }

  @override
  void initState() {
    super.initState();
    _image = null;
    _lat = widget.latitude;
    _lon = widget.longitude;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
      child: Form(
        key: widget.formKey, 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Sizing.horizontalPadding,),
            ProfilePictureInput(
              onSelected: _onSelected,
              image: _image,
              child: (_showChild && widget.profilePicture.isNotEmpty)
                ? ProfilePictureDisplay(size: 60, iconSize: 32, profilePicture: widget.profilePicture)
                : null,
            ),
            const SizedBox(height: Sizing.horizontalPadding,),
            // First & last name input
            Row(
              children: [
                Flexible(
                  // First name input
                  child: TextInput(
                    initialValue: widget.firstName,
                    label: l10n.firstName,
                    hint: "John",
                    textInputAction: TextInputAction.next,
                    onChanged: widget.onChangeMade,
                  ),
                ),
                const SizedBox(width: Sizing.inputSpacing,),
                Flexible(
                  // Last name input
                  child: TextInput(
                    initialValue: widget.lastName,
                    label: l10n.lastName,
                    hint: "Doe",
                    textInputAction: TextInputAction.next,
                    onChanged: widget.onChangeMade,
                  ),
                ),
              ]
            ),
            const SizedBox(height: Sizing.horizontalPadding,),
            // Username input
            TextInput(
              initialValue: widget.username,
              label: l10n.username,
              hint: "@johndoe",
              textInputAction: TextInputAction.next,
              tooltipText: l10n.usernameTooltip,
              onChanged: widget.onChangeMade,
            ),
            const SizedBox(height: Sizing.horizontalPadding,),
            // Bio input
            TextInput(
              textInputAction: TextInputAction.done,
              initialValue: widget.bio,
              label: l10n.biography,
              optional: true,
              hint: l10n.bioPlaceholder,
              maxLength: 150,
              minLines: 3,
              maxLines: null,
              onChanged: widget.onChangeMade,
            ),
            const SizedBox(height: Sizing.horizontalPadding,),
            // Location
            ProfileEditLocationDisplay(
              mapController: _mapController,
              location: _lat == 1000 ? null : LatLng(_lat, _lon),
              locationName: widget.locationName,
              onLocationChanged: (LatLng? location) {
                widget.onChangeMade(null);
                setState(() {
                  _lat = location?.latitude ?? 1000;
                  _lon = location?.longitude ?? 1000;

                  if (location != null)
                    _mapController.move(location, 10);
                });
              },
            )
          ]
        )
      ),
    );
  }
}

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _madeChanges = false;
  XFile? _pfp;

  void _handleSubmit() {
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
                  return _ProfileEditForm(
                    formKey: _formKey,
                    profilePicture: value.profilePicture,
                    firstName: value.firstName,
                    lastName: value.lastName,
                    username: value.username,
                    bio: value.bio,
                    latitude: value.lat.toDouble(),
                    longitude: value.lon.toDouble(),
                    locationName: value.locationText,
                    onProfilePictureSelected: (XFile? file) {
                      setState(() {
                        _madeChanges = true;
                        _pfp = file;
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
