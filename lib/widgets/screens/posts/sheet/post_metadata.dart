import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taskbuddy/api/responses/posts/post_response.dart';
import 'package:taskbuddy/state/static/location_state.dart';
import 'package:taskbuddy/utils/dates.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostData extends StatelessWidget {
  final PostResponse post;

  const PostData({ Key? key, required this.post }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(width: Sizing.horizontalPadding,),
              if (post.locationText != '' || post.locationLat != 1000)
                Icon(
                  Icons.location_on_outlined,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 18,
                ),
              if (post.locationText != '')
                Text(
                  '${post.locationText} • ',
                  style: Theme.of(context).textTheme.bodySmall
                ),
              if (post.locationLat != 1000 && LocationState.currentLat != 1000)
                Text(
                  '${(Geolocator.distanceBetween(LocationState.currentLat, LocationState.currentLon, post.locationLat, post.locationLon) / 1000).round()} km • ',
                  style: Theme.of(context).textTheme.bodySmall
                ),
              Text(
                'available ${Dates.timeAgo(post.startDate, Locale(AppLocalizations.of(context)!.localeName))} • expires ${Dates.timeAgo(post.endDate, Locale(AppLocalizations.of(context)!.localeName))}',
                style: Theme.of(context).textTheme.bodySmall
              ),

              const SizedBox(width: Sizing.horizontalPadding,),
            ],
          )
        )        
      ],
    );
  }
}