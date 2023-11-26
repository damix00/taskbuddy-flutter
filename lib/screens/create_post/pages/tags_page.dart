import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/screens/create_post/title_desc.dart';
import 'package:taskbuddy/state/providers/tags.dart';
import 'package:taskbuddy/state/static/create_post_state.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/with_state/content/tag_picker.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:taskbuddy/widgets/navigation/blur_parent.dart';
import 'package:taskbuddy/widgets/ui/platforms/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class CreatePostTagsPage extends StatelessWidget {
  const CreatePostTagsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: Text(
          l10n.editMedia,
          style: Theme.of(context).textTheme.titleSmall
        )
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: const _PageContent(),
    );
  }
}

class _PageContent extends StatefulWidget {
  const _PageContent({Key? key}) : super(key: key);

  @override
  State<_PageContent> createState() => _PageContentState();
}

class _PageContentState extends State<_PageContent> {
  List<Tag> _selectedTags = [];

  int _minTags = 1;
  int _maxTags = 10;

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
          child: ScrollbarSingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + Sizing.horizontalPadding,),
                CreatePostTitleDesc(
                  title: l10n.chooseTags,
                  desc: l10n.chooseTagsDesc(_minTags, _maxTags),
                ),
                const SizedBox(height: Sizing.inputSpacing),
                TagPicker(
                  selectable: true,
                  max: _maxTags,
                  selectedTags: _selectedTags,
                  onSelect: (tags) {
                    setState(() {
                      _selectedTags = tags;
                    });

                    CreatePostState.tags = tags;
                  },
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 75),
              ],
            ),
          ),
        ),
        // Continue buttom on the bottom, always visible
        Positioned(
          bottom: 0,
          left: 0,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).padding.bottom + 75,
            child: BlurParent(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Button(
                      disabled: _selectedTags.length < _minTags,
                      child: ButtonText(l10n.continueText),
                      onPressed: () {}
                    ),
                    SizedBox(height: MediaQuery.of(context).padding.bottom),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
