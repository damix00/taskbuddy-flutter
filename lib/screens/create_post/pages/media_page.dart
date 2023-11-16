import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskbuddy/screens/create_post/page_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/screens/create_post/pages/edit_media_page.dart';
import 'package:taskbuddy/screens/create_post/title_desc.dart';
import 'package:taskbuddy/state/static/create_post_state.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/screens/create_post/media_pageview.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class CreatePostMedia extends StatefulWidget {
  const CreatePostMedia({ Key? key }) : super(key: key);

  @override
  State<CreatePostMedia> createState() => _CreatePostMediaState();
}

class _CreatePostMediaState extends State<CreatePostMedia> {
  int _itemCount = CreatePostState.media.length;

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return CreatePostPageLayout(
      title: l10n.newPost,
      page: _ScreenContent(
        onItemCountChanged: (v) {
          setState(() {
            _itemCount = v;
          });
        },
      ),
      bottom: CreatePostBottomLayout(
        children: [
          Button(
            disabled: _itemCount < 3,
            child: ButtonText(l10n.continueText),
            onPressed: () {
              Navigator.of(context).pushNamed('/create-post/date-price');
            },
          ),
        ]
      ),
    );
  }
}

class _ScreenContent extends StatefulWidget {
  final Function(int) onItemCountChanged;

  const _ScreenContent({
    required this.onItemCountChanged,
    Key? key
  }) : super(key: key);

  @override
  State<_ScreenContent> createState() => _ScreenContentState();
}

class _ScreenContentState extends State<_ScreenContent> {
  List<XFile> items = CreatePostState.media;

  @override
  Widget build(BuildContext context) {
    double size = min(MediaQuery.of(context).size.width - Sizing.horizontalPadding * 2, 300);
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top + Sizing.horizontalPadding,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
          child: CreatePostTitleDesc(
            title: l10n.addMedia,
            desc: l10n.addMediaDesc,
          ),
        ),
        const SizedBox(height: Sizing.formSpacing),
        MediaPageView(
          items: items,
          size: size,
          onItemsChanged: (v, reset) {
            if (reset) {
              items = v;
            } else {
              items.addAll(v);
            }

            widget.onItemCountChanged(items.length);

            CreatePostState.media = items;

            setState(() {}); // Update the UI
          }
        ),
        const SizedBox(height: Sizing.inputSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Button(
              disabled: items.isEmpty,
              type: ButtonType.outlined,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 12),
                  Icon(
                    Icons.edit,
                    size: 20,
                    color: Theme.of(context).colorScheme.onBackground
                  ),
                  const SizedBox(width: 8),
                  Text(l10n.edit),
                  const SizedBox(width: 12),
                ],
              ),
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => CreatePostMediaEdit(
                      items: List.from(items), // Copy the list to prevent editing the original
                      onItemsChanged: (v) {
                        setState(() {
                          items = v;
                          widget.onItemCountChanged(items.length);
                        });

                        CreatePostState.media = v;
                      },
                    )
                  )
                );
              },
            ),
            const SizedBox(width: Sizing.horizontalPadding),
          ],
        ),
      ],
    );
  }
}
