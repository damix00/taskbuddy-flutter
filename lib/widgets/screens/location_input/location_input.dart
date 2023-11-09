import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/screens/location_input/bottom_sheet.dart';
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
  final Function(LatLng)? onLocationSelected;

  LocationInputArguments({
    this.initPosition,
    this.onLocationSelected
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
                args.onLocationSelected?.call(center);
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
                initialCenter: args.initPosition ?? LatLng(0, 0),
                initialZoom: 10,
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
                Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * minSnapSize),
                  child: const OSMAttribution()
                )
              ],
            )
          ),
          Center(child: Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary, size: 40,)),
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