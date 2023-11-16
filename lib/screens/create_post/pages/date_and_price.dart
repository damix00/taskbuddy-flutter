import 'package:flutter/material.dart';
import 'package:taskbuddy/screens/create_post/page_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/screens/create_post/title_desc.dart';

class CreatePostDatePrice extends StatelessWidget {
  const CreatePostDatePrice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return CreatePostPageLayout(
      title: l10n.newPost,
      page: const _PageContent(),
      bottom: Container()
    );
  }
}

class _PageContent extends StatelessWidget {
  const _PageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return CreatePostContentLayout(
      children: [
        CreatePostTitleDesc(
          title: l10n.selectStartEnd,
          desc: l10n.selectStartEndDesc,
        ),
      ],
    );
  }
}
