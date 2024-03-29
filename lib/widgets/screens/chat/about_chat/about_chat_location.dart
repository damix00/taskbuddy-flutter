import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:taskbuddy/api/responses/chats/channel_response.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/input/with_state/location_display.dart';

class AboutChatLocation extends StatelessWidget {
  final ChannelResponse channel;

  const AboutChatLocation({Key? key, required this.channel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    if (channel.post.isRemote) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.location,
            style: Theme.of(context).textTheme.displaySmall
          ),
          const SizedBox(height: 8),
          Text(
            l10n.remoteText,
            style: Theme.of(context).textTheme.bodyMedium
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.location,
          style: Theme.of(context).textTheme.displaySmall
        ),
        LocationDisplay(
          location: LatLng(channel.post.locationLat, channel.post.locationLon),
          locationName: channel.post.locationText,
          optional: false,
          showEditButton: false,
        )
      ],
    );
  }
}