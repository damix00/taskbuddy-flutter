import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:taskbuddy/widgets/input/input_title.dart';
import 'package:taskbuddy/widgets/input/touchable/touchable.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileEditLocationDisplay extends StatelessWidget {
  final LatLng? location;
  final String? locationName;

  const ProfileEditLocationDisplay({
    this.location,
    this.locationName,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputTitle(title: l10n.location, optional: true, tooltipText: l10n.locationTooltipProfile),
        const SizedBox(height: Sizing.inputSpacing,),
        Touchable(
          onTap: () {
            
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 200,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: location!,
                  initialZoom: 10,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'app.taskbuddy.flutter',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: location!,
                        child: const Icon(Icons.location_on)
                      )
                    ],
                  ),
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                        onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ),
        ),
      ],
    );
  }
}