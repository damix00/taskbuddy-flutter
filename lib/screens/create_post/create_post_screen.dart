import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/screens/create_post/title_desc.dart';
import 'package:taskbuddy/state/static/create_post_state.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/touchable/checkbox.dart';
import 'package:taskbuddy/widgets/input/touchable/radio.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/ui/platforms/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Text(
              l10n.newPost,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
        showLeading: false
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
        child: ScrollbarSingleChildScrollView(
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
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}

class _ScreenContent extends StatefulWidget {
  const _ScreenContent({Key? key}) : super(key: key);

  @override
  State<_ScreenContent> createState() => _ScreenContentState();
}

class _ScreenContentState extends State<_ScreenContent> {
  int _selected = PostType.oneTime.index;
  bool _urgent = false;

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).padding.top + Sizing.horizontalPadding,
        ),
        CreatePostTitleDesc(
          title: l10n.chooseTypeOfJob,
          desc: l10n.chooseTypeOfJobDesc
        ),
        const SizedBox(height: Sizing.inputSpacing),
        RadioButtons(
          onChanged: (v) {
            setState(() {
              _selected = v;
            });

            CreatePostState.postType = PostType.values[v];
          },
          selected: _selected,
          items: [
            RadioItem(
              title: l10n.oneTimeJob,
              subtitle: l10n.oneTimeJobDesc,
            ),
            RadioItem(
              title: l10n.partTimeJob,
              subtitle: l10n.partTimeJobDesc,
            ),
            RadioItem(
              title: l10n.fullTimeJob,
              subtitle: l10n.fullTimeJobDesc,
            ),
          ]
        ),
        const SizedBox(height: Sizing.formSpacing),
        TBCheckbox(
          onChanged: (v) {
            setState(() {
              _urgent = v;
            });
            CreatePostState.isUrgent = v;
          },
          value: _urgent,
          child: TitleDescSmall(
            title: l10n.urgent,
            desc: l10n.urgentDesc,
          )
        ),
      ]
    );
  }
}