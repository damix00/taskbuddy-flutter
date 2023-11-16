import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:taskbuddy/screens/create_post/title_desc.dart';
import 'package:taskbuddy/state/static/create_post_state.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/touchable/radio.dart';
import 'package:taskbuddy/widgets/input/touchable/unclickable.dart';
import 'package:taskbuddy/widgets/input/with_state/location_display.dart';
import 'package:taskbuddy/widgets/input/with_state/slider.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:taskbuddy/widgets/ui/platforms/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class CreatePostLocation extends StatelessWidget {
  const CreatePostLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: Text(
          l10n.newPost,
          style: Theme.of(context).textTheme.titleSmall,
        )
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: ScrollbarSingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const _ScreenContent(),
                Column(
                  children: [
                    Button(
                      onPressed: () => Navigator.of(context).pushNamed('/create-post/location'),
                      child: Text(
                        l10n.continueText,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary
                        )
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).padding.bottom + Sizing.horizontalPadding),
                  ],
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}

class _ScreenContent extends StatefulWidget {
  const _ScreenContent({Key? key}) : super(key: key);

  @override
  State<_ScreenContent> createState() => _ScreenContentState();
}

class _ScreenContentState extends State<_ScreenContent> {
  final MapController _mapController = MapController();
  LatLng? _location = CreatePostState.location;
  String? _locationName = CreatePostState.locationName;
  int _selected = CreatePostState.isRemote ? 1 : 0;
  double _radius = CreatePostState.suggestionRadius;

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top + Sizing.horizontalPadding,),
        CreatePostTitleDesc(
          title: l10n.chooseLocation,
          desc: l10n.chooseLocationDesc
        ),
        const SizedBox(height: Sizing.inputSpacing,),
        RadioButtons(
          onChanged: (v) {
            setState(() {
              _selected = v;
            });

            CreatePostState.isRemote = v == 1;
          },
          selected: _selected,
          items: [
            RadioItem(
              title: l10n.itHasALocation,
              subtitle: l10n.itHasALocationDesc,
            ),
            RadioItem(
              title: l10n.itDoesntHaveALocation,
              subtitle: l10n.itDoesntHaveALocationDesc,
            ),
          ]
        ),
        const SizedBox(height: Sizing.inputSpacing,),
        // Make the map clickable if the user has selected that the post has a location
        Unclickable(
          enabled: _selected == 0,
          // Make the map less visible if the user has selected that the post doesn't have a location
          child: AnimatedOpacity(
            opacity: _selected == 0 ? 1 : 0.3,
            duration: const Duration(milliseconds: 200),
            child: LocationDisplay(
              optional: false,
              mapController: _mapController,
              location: _location,
              locationName: _locationName,
              onLocationChanged: (pos, name) {
                setState(() {
                  _location = pos;
                  _locationName = name;
                });

                CreatePostState.location = pos;
                CreatePostState.locationName = name;
              }
            ),
          ),
        ),
        const SizedBox(height: Sizing.formSpacing,),
        // Add a slider for the user to choose the radius of where the post can be suggested
        TBSlider(
          title: l10n.suggestionRadius,
          subtitle: l10n.suggestionRadiusDesc,
          unit: 'km',
          value: _radius,
          min: 10,
          max: 100,
          onChanged: (v) {
            setState(() {
              _radius = v;
            });
          }
        ),
        const SizedBox(height: Sizing.formSpacing,),
      ],
    );
  }
}
