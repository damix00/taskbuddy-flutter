import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:taskbuddy/widgets/input/with_state/location_display.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:taskbuddy/api/responses/posts/post_results_response.dart';

class PostLocationDisplay extends StatelessWidget {
  final PostResultsResponse post;

  const PostLocationDisplay({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (post.isRemote) return Container();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
      child: LocationDisplay(
        location: LatLng(post.locationLat, post.locationLon),
        locationName: post.locationText,
        showEditButton: false,
        radius: 1,
        zoom: 13,
      )
    );
  }
}