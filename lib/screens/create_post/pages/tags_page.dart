import 'package:flutter/material.dart';
import 'package:taskbuddy/screens/create_post/page_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/screens/create_post/title_desc.dart';
import 'package:taskbuddy/widgets/input/with_state/content/tag_picker.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class CreatePostTagsPage extends StatelessWidget {
  const CreatePostTagsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return CreatePostPageLayout(
      title: l10n.newPost,
      page: CreatePostContentLayout(
        children: [
          CreatePostTitleDesc(
            title: l10n.chooseTags,
            desc: l10n.chooseTagsDesc,
          ),
          const SizedBox(height: Sizing.inputSpacing),
          const TagPicker(selectable: true,),
        ],
      ),
      bottom: Container(),
    );
  }
}
