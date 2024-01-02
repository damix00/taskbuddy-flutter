import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taskbuddy/api/responses/chats/channel_response.dart';
import 'package:taskbuddy/api/responses/posts/post_only_response.dart';
import 'package:taskbuddy/state/static/location_state.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class ChatPostInfo extends StatelessWidget {
  final ChannelResponse channel;

  const ChatPostInfo({
    Key? key,
    required this.channel
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PostOnlyResponse post = channel.post;

    return Padding(
      padding: const EdgeInsets.all(Sizing.horizontalPadding),
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: post.media[0],
                fit: BoxFit.cover
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                post.title,
                style: Theme.of(context).textTheme.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                " • €${post.price}",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (post.locationText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 2.0),
                  child: Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              if (post.locationText.isNotEmpty)
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Text(
                      "${post.locationText} •",
                      style: Theme.of(context).textTheme.labelMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              
              if (post.locationLat != 1000 && post.locationLon != 1000)
                Text(
                  "${(Geolocator.distanceBetween(
                    LocationState.currentLat,
                    LocationState.currentLon,
                    post.locationLat,
                    post.locationLon
                  ) / 1000).round()} km",
                  style: Theme.of(context).textTheme.labelMedium
                ),
            ],
          ),
        ],
      ),
    );
  }
}