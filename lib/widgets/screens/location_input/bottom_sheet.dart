import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:taskbuddy/widgets/input/search_input.dart';
import 'package:taskbuddy/widgets/navigation/blur_parent.dart';
import 'package:taskbuddy/widgets/screens/location_input/search.dart';

class LocationInputBottomSheet extends StatefulWidget {
  final MapController mapController;
  final DraggableScrollableController sheetController;
  final double minSnapSize;
  final double maxSnapSize;
  final ScrollController scrollConroller;

  const LocationInputBottomSheet({
    required this.mapController,
    required this.sheetController,
    required this.minSnapSize,
    required this.maxSnapSize,
    required this.scrollConroller,
    Key? key
  }) : super(key: key);

  @override
  State<LocationInputBottomSheet> createState() => _LocationInputBottomSheetState();
}

class _LocationInputBottomSheetState extends State<LocationInputBottomSheet> {
  final Duration _animationDuration = const Duration(milliseconds: 300);

  double _borderRadius = 16;
  String _searchQuery = '';
  Timer _debounce = Timer(const Duration(milliseconds: 300), () {});

  @override
  void initState() {
    super.initState();

    widget.sheetController.addListener(() {
      var screenHeight = MediaQuery.of(context).size.height;

      if (widget.sheetController.pixels.floor() >= (screenHeight * widget.maxSnapSize.floor()) && _borderRadius != 0) {
        setState(() {
          _borderRadius = 0;
        });
      }
      else if (widget.sheetController.pixels.floor() <= (screenHeight * widget.minSnapSize).floor() && _borderRadius != 16) {
        setState(() {
          _borderRadius = 16;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(_borderRadius),
        topRight: Radius.circular(_borderRadius)
      ),
      child: BlurParent(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            children: [
              // Scroll view consisting of the search input and results
              CustomScrollView(
                controller: widget.scrollConroller,
                slivers: [
                  SliverToBoxAdapter(
                    // Search input
                    child: Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: SearchInput (
                        hintText: l10n.searchPlaceholder,
                        onTap: () {
                          // Expand the sheet
                          widget.sheetController.animateTo(
                            widget.maxSnapSize,
                            duration: _animationDuration,
                            curve: Curves.easeOut
                          );
                        },
                        onChanged: (v) {
                          // Debounce the search query (to avoid spamming the API)
                          _debounce.cancel();
                          _debounce = Timer(const Duration(milliseconds: 300), () {
                            setState(() {
                              _searchQuery = v;
                            });
                          });
                        },
                      ),
                    ),
                  ),
                  // Display the search results
                  SearchResults(
                    query: _searchQuery,
                    onResultSelected: (result) {
                      // Hide the keyboard
                      FocusScope.of(context).unfocus();

                      // Minimize the sheet
                      widget.sheetController.animateTo(
                        widget.minSnapSize,
                        duration: _animationDuration,
                        curve: Curves.easeOut
                      );

                      // Move the map to the selected result
                      widget.mapController.move(result.position, 18);
                    },
                  )
                ],
              ),
              // Resize indicator
              Center(
                heightFactor: 0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    )
                  ),
                ),
              ),
            ],
          )
        )
      ),
    );
  }
}