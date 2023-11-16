import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/screens/create_post/title_desc.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
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

class _ScreenContent extends StatelessWidget {
  const _ScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top + Sizing.horizontalPadding,),
        CreatePostTitleDesc(
          title: 'choose location',
          desc: 'desc'
        )
      ],
    );
  }
}
