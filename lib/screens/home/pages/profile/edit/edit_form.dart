import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:taskbuddy/screens/home/pages/profile/edit/location_display.dart';
import 'package:taskbuddy/utils/validators.dart';
import 'package:taskbuddy/widgets/input/pfp_input.dart';
import 'package:taskbuddy/widgets/input/text_input.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileEditForm extends StatefulWidget {
  final String profilePicture;
  final String firstName;
  final String lastName;
  final String username;
  final String bio;
  final double? latitude;
  final double? longitude;
  final String locationName;
  final Function(XFile?) onProfilePictureSelected;
  final Function(String?) onChangeMade;
  final Function(LocationData?) onLocationChanged;
  final Function(String) onFirstNameChanged;
  final Function(String) onLastNameChanged;
  final Function(String) onUsernameChanged;
  final Function(String) onBioChanged;

  final formKey;

  const ProfileEditForm({
    required this.profilePicture,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.formKey,
    required this.onProfilePictureSelected,
    required this.onChangeMade,
    required this.onLocationChanged,
    required this.onFirstNameChanged,
    required this.onLastNameChanged,
    required this.onUsernameChanged,
    required this.onBioChanged,
    this.locationName = '',
    this.latitude,
    this.longitude,
    this.bio = '',
    Key? key
  }) : super(key: key);

  @override
  __ProfileEditFormState createState() => __ProfileEditFormState();
}

class __ProfileEditFormState extends State<ProfileEditForm> {
  final MapController _mapController = MapController();

  bool _showChild = true;
  XFile? _image;
  double? _lat;
  double? _lon;
  String _locationName = '';

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
    _locationName = widget.locationName;
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
                    onChanged: (String value) {
                      widget.onChangeMade(value);
                      widget.onFirstNameChanged(value);
                    },
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return l10n.emptyField(l10n.lastName);
                      }
                      return null;
                    }
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
                    onChanged: (String value) {
                      widget.onChangeMade(value);
                      widget.onLastNameChanged(value);
                    },
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return l10n.emptyField(l10n.lastName);
                      }
                      return null;
                    }
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
              onChanged: (String value) {
                widget.onChangeMade(value);
                widget.onUsernameChanged(value);
              },
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return l10n.emptyField(l10n.username);
                }

                return Validators.validateUsername(context, v);
              }
            ),
            const SizedBox(height: Sizing.horizontalPadding,),
            // Bio input
            TextInput(
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              initialValue: widget.bio,
              label: l10n.biography,
              optional: true,
              hint: l10n.bioPlaceholder,
              maxLength: 150,
              minLines: 3,
              maxLines: null,
              onChanged: (String value) {
                widget.onChangeMade(value);
                widget.onBioChanged(value);
              },
            ),
            const SizedBox(height: Sizing.horizontalPadding,),
            // Location
            ProfileEditLocationDisplay(
              mapController: _mapController,
              location: _lat == null || _lon == null ? null : LatLng(_lat!, _lon!),
              locationName: _locationName,
              onLocationChanged: (LatLng? location, String? name) {
                widget.onChangeMade(null);
                widget.onLocationChanged(location == null ? null : LocationData(location: location, locationName: name ?? ''));

                setState(() {
                  _lat = location?.latitude;
                  _lon = location?.longitude;
                  _locationName = name ?? '';

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