import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:taskbuddy/widgets/input/search_input.dart';
import 'package:taskbuddy/widgets/input/text_input.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/navigation/blur_parent.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchResults extends StatefulWidget {
  final String query;

  const SearchResults({
    required this.query,
    Key? key
  }) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  @override
  Widget build(BuildContext context) {
    print('render');

    return Text(widget.query);
  }
}

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

  double _borderRadius = 16;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _sheetController.addListener(() {
      var screenHeight = MediaQuery.of(context).size.height;
      var maxSnapSize = screenHeight * (1 - (MediaQuery.of(context).padding.top + Sizing.appbarHeight) / MediaQuery.of(context).size.height);
      var minSnapSize = (MediaQuery.of(context).padding.bottom + _minHeight) / MediaQuery.of(context).size.height;

      if (_sheetController.pixels.floor() >= maxSnapSize.floor() && _borderRadius != 0) {
        setState(() {
          _borderRadius = 0;
        });
      }
      else if (_sheetController.pixels.floor() <= (screenHeight * minSnapSize).floor() && _borderRadius != 16) {
        setState(() {
          _borderRadius = 16;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
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
              return ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_borderRadius),
                  topRight: Radius.circular(_borderRadius)
                ),
                child: BlurParent(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      controller: scrollConroller,
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              height: 4,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(4),
                              )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: SearchInput(
                              hintText: l10n.searchPlaceholder,
                              onTap: () {
                                // Expand the sheet
                                _sheetController.animateTo(
                                  maxSnapSize,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeOut
                                );
                              },
                              onChanged: (v) {
                                // debounce
                                Future.delayed(Duration(milliseconds: 300), () {
                                  if (v != _searchQuery) {
                                    setState(() {
                                      _searchQuery = v;
                                    });
                                  }
                                });
                              },
                            ),
                          ),
                          SearchResults(query: _searchQuery)
                        ],
                      ),
                    )
                  )
                ),
              );
            },
          )
        ],
      )
    );
  }
}