import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/navigation/blur_parent.dart';
import 'package:taskbuddy/widgets/ui/platforms/loader.dart';

class LocationNameDisplay extends StatelessWidget {
  final String locationName;
  final bool loadingName;

  const LocationNameDisplay({
    required this.locationName,
    required this.loadingName
  }) : super();

  @override
  Widget build(BuildContext context) {
    // Ignore all tap events on this widget, so that the map can be interacted with
    return IgnorePointer(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: MediaQuery.of(context).padding.top + 8
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: BlurParent(
            child: Container(
              width: double.infinity,
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: loadingName ? const Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CrossPlatformLoader(),
                ),
              ) : Center(
                child: Text(
                  locationName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        )
      ),
    );
  }
}