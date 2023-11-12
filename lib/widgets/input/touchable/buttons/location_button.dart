import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:taskbuddy/utils/utils.dart';
import 'package:taskbuddy/widgets/ui/feedback/snackbars.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationButton extends StatefulWidget {
  final Function(LatLng) onTap;
  final String? locationName;

  const LocationButton({
    required this.onTap,
    this.locationName,
    Key? key
  }) : super(key: key);

  @override
  State<LocationButton> createState() => _LocationButtonState();
}

class _LocationButtonState extends State<LocationButton> {
  // For the location button
  bool _canGetLocation = true;
  late StreamSubscription<ServiceStatus> _serviceStatusStream;

  void _init() async {
    _canGetLocation = await Utils.canGetLocation();

    // Update the UI
    setState(() {
    });

    Geolocator.getServiceStatusStream().listen(
      (ServiceStatus status) {
        _canGetLocation = status == ServiceStatus.enabled;

        // Update the UI
        setState(() {
        });
      }
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  @override
  void dispose() {
    super.dispose();

    _serviceStatusStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return SizedBox(
      width: 48,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.zero
        ),
        onPressed: () async {
          if (!(await Utils.canGetLocation())) {
            SnackbarPresets.show(
              context,
              text: l10n.locationOff
            );
          }

          widget.onTap((await Utils.getCurrentLocation())!);
        },
        child: Icon(
          _canGetLocation ? Icons.location_searching_sharp : Icons.location_disabled,
          color: Colors.white),
      ),
    );
  }
}