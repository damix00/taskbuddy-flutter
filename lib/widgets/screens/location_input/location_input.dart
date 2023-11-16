import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:taskbuddy/api/geo/osm_api.dart';
import 'package:taskbuddy/utils/constants.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/location_button.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/screens/location_input/bottom_sheet.dart';
import 'package:taskbuddy/widgets/screens/location_input/input_overlay.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:url_launcher/url_launcher.dart';

class OSMAttribution extends StatelessWidget {
  const OSMAttribution({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichAttributionWidget(
      attributions: [
        TextSourceAttribution(
          'OpenStreetMap contributors',
          onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
        ),
      ],
    );
  }
}

class LocationInputArguments {
  final LatLng? initPosition;
  final Function(LatLng, String? locationName)? onLocationSelected;
  final String? locationName;

  LocationInputArguments({
    this.initPosition,
    this.onLocationSelected,
    this.locationName
  });
}

class LocationInputScreen extends StatefulWidget {
  const LocationInputScreen({
    Key? key
  }) : super(key: key);

  @override
  _LocationInputScreenState createState() => _LocationInputScreenState();
}

class _LocationInputScreenState extends State<LocationInputScreen> {
  final MapController _mapController = MapController();

  // For the bottom sheet
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  final _minHeight = 92.0;

  String _locationName = '';
  bool _loadingName = false;

  Timer _debounce = Timer(const Duration(milliseconds: 300), () => {});

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var args = ModalRoute.of(context)!.settings.arguments as LocationInputArguments;

      setState(() {
        _locationName = args.locationName ?? '';
      });
    });
  }

  @override
  void dispose() {
    _debounce.cancel();
    _mapController.dispose();
    super.dispose();
  }

  // Called when the map position changes
  void onPositionChanged(MapPosition position, bool hasGesture) {
    _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      setState(() {
        _loadingName = true;
      });

      var response = await OSMApi.getLocationName(position.center!);

      if (response?.response == null || response!.timedOut || response.response!.statusCode != 200) {
        setState(() {
          _loadingName = false;
          _locationName = '';
        });

        return;
      }

      var data = response.response!.data;

      String? name = data["address"]?["village"] ??
        data["address"]?["city"] ??
        data["address"]?["town"] ??
        data["address"]["county"] ??
        ((data["name"] ?? '').isNotEmpty ? data["name"] : null) ??
        data["country"];

      setState(() {
        _locationName = name ?? '';
        _loadingName = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as LocationInputArguments;

    var maxSnapSize = 1 - (MediaQuery.of(context).padding.top + Sizing.appbarHeight) / MediaQuery.of(context).size.height;
    var minSnapSize = (MediaQuery.of(context).padding.bottom + _minHeight) / MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.close, size: 24, color: Theme.of(context).colorScheme.onBackground,),
              onPressed: () async {
                Navigator.of(context).pop();
              }
            ),
            Text(
              AppLocalizations.of(context)!.chooseLocation,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const Spacer(),
            IconButton(
              icon: Icon(Icons.check, size: 24, color: Theme.of(context).colorScheme.primary),
              onPressed: () {
                var center = _mapController.camera.center;
                args.onLocationSelected?.call(center, _locationName);
                Navigator.of(context).pop(center);
              },
            ),
          ],
        ),
        showLeading: false
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: args.initPosition ?? Constants.getInitialLocation(),
                initialZoom: 10,
                onPositionChanged: onPositionChanged,
                minZoom: 0,
                maxZoom: 18,
                interactionOptions: InteractionOptions(
                  rotationThreshold: 40
                )
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'app.taskbuddy.flutter',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: args.initPosition ?? Constants.getInitialLocation(),
                      child: const Icon(Icons.location_on, color: Colors.red),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * minSnapSize + 64),
                  child: const OSMAttribution()
                )
              ],
            )
          ),
          LocationNameDisplay(locationName: _locationName, loadingName: _loadingName),
          // Marker for the center of the map
          Center(child: Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary, size: 40,)),
          // Current location button
          Positioned(
            bottom: MediaQuery.of(context).size.height * minSnapSize + 16,
            right: 16,
            child: LocationButton(
              onTap: (value) {
                _mapController.move(value, 18);
              },
            ),
          ),
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: minSnapSize,
            maxChildSize: maxSnapSize,
            minChildSize: minSnapSize,
            expand: true,
            snap: true,
            snapSizes: [minSnapSize, maxSnapSize],
            builder: (ctx, scrollConroller) {
              return LocationInputBottomSheet(
                mapController: _mapController,
                sheetController: _sheetController,
                maxSnapSize: maxSnapSize,
                minSnapSize: minSnapSize,
                scrollConroller: scrollConroller,
              );
            },
          )
        ],
      )
    );
  }
}
