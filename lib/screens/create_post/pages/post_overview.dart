import 'dart:io';

import 'package:flutter/material.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/screens/create_post/title_desc.dart';
import 'package:taskbuddy/screens/create_post/value_display.dart';
import 'package:taskbuddy/state/static/create_post_state.dart';
import 'package:taskbuddy/utils/utils.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/ui/platforms/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:taskbuddy/widgets/ui/tag_widget.dart';
import 'package:taskbuddy/widgets/ui/visual/divider.dart';

class CreatePostOverviewPage extends StatelessWidget {
  const CreatePostOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: AppbarTitle(l10n.reviewYourPost)
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: const ScrollbarSingleChildScrollView(
        child: _ScreenContent(),
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
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top + Sizing.horizontalPadding),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
          child: CreatePostTitleDesc(
            title: l10n.reviewYourPost,
            desc: l10n.reviewYourPostDesc,
          ),
        ),
        const SizedBox(height: Sizing.formSpacing),
        // Post type
        ValueDisplay(title: l10n.typeOfJob, value: CreatePostState.postTypeToString(l10n)),
        const CustomDivider(padding: Sizing.inputSpacing),
        // Urgent?
        ValueDisplay(title: l10n.urgent, value: CreatePostState.isUrgent ? l10n.yes : l10n.no),
        const CustomDivider(padding: Sizing.inputSpacing),
        // Location
        ValueDisplay(title: l10n.location, value: CreatePostState.isRemote ? l10n.remote : CreatePostState.locationName ?? l10n.remote),
        const CustomDivider(padding: Sizing.inputSpacing),
        // Suggestion radius
        ValueDisplay(title: l10n.suggestionRadius, value: '${CreatePostState.suggestionRadius.toStringAsFixed(2)} km'),
        const CustomDivider(padding: Sizing.inputSpacing),
        // Title
        ValueDisplay(title: l10n.title, value: CreatePostState.title),
        const CustomDivider(padding: Sizing.inputSpacing),
        // Description
        ValueDisplay(title: l10n.description, value: CreatePostState.description.replaceAll('\n', ' ')),
        const CustomDivider(padding: Sizing.inputSpacing),
        // Media
        ValueDisplay(title: '${l10n.media} (${CreatePostState.media.length})', value: ''),
        const SizedBox(height: 8,),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: CreatePostState.media.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? Sizing.horizontalPadding : 0,
                  right: index == CreatePostState.media.length - 1 ? Sizing.horizontalPadding : 8,
                ),
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: FileImage(File(CreatePostState.media[index].path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const CustomDivider(padding: Sizing.inputSpacing),
        // dates
        ValueDisplay(title: l10n.startDate, value: Utils.formatDate(CreatePostState.startDate!)),
        const CustomDivider(padding: Sizing.inputSpacing),
        ValueDisplay(title: l10n.endDate, value: Utils.formatDate(CreatePostState.endDate!)),
        const CustomDivider(padding: Sizing.inputSpacing),
        // Price
        ValueDisplay(title: l10n.price, value: '${CreatePostState.price} €'),
        const CustomDivider(padding: Sizing.inputSpacing),
        // Tags
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
              child: Text(
                '${l10n.tags} (${CreatePostState.tags.length})',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 8,),
            SizedBox(
              height: 30,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: CreatePostState.tags.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? Sizing.horizontalPadding : 0,
                      right: index == CreatePostState.tags.length - 1 ? Sizing.horizontalPadding : 8,
                    ),
                    child: TagWidget(
                      tag: CreatePostState.tags[index],
                      selected: false,
                      onSelect: (selected) {},
                      isSelectable: false,
                    ),
                  );
                },
              ),
            )
          ]
        ),
        const SizedBox(height: Sizing.formSpacing,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
          child: Button( // The submit button
            child: ButtonText(l10n.postBtn),
            loading: _loading,
            onPressed: () async {
              var token = (await AccountCache.getToken())!;

              setState(() {
                _loading = true;
              });

              print("sending request");

              var result = await Api.v1.posts.createPost(
                token, // JWT
                jobType: CreatePostState.postType, // The post type (enum) (one-time, part-time, full-time)
                title: CreatePostState.title, // Title
                description: CreatePostState.description, // Description of the post
                locationLat: CreatePostState.location?.latitude, // The location
                locationLon: CreatePostState.location?.longitude, // The location
                locationName: CreatePostState.locationName, // The location name
                isRemote: CreatePostState.isRemote, // Is it remote?
                isUrgent: CreatePostState.isUrgent, // Is it urgent?
                price: CreatePostState.price, // The price
                suggestionRadius: CreatePostState.suggestionRadius, // The suggestion radius
                startDate: CreatePostState.startDate!, // When the post starts
                endDate: CreatePostState.endDate!, // When the post ends
                tags: CreatePostState.tags.map((e) => e.id).toList(), // Convert tags to a list of ids
                media: CreatePostState.media, // XFile list of media
              );

              print(result.data);

              setState(() {
                _loading = false;
              });
            },
          ),
        ),

        SizedBox(height: MediaQuery.of(context).padding.bottom + Sizing.horizontalPadding),
      ]
    );
  }
}
