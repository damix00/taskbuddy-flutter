import 'package:flutter/material.dart';
import 'package:taskbuddy/screens/create_post/page_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/screens/create_post/title_desc.dart';
import 'package:taskbuddy/state/static/create_post_state.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/with_state/text_inputs/text_input.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class CreatePostTitle extends StatefulWidget {
  const CreatePostTitle({Key? key}) : super(key: key);

  @override
  State<CreatePostTitle> createState() => _CreatePostTitleState();
}

class _CreatePostTitleState extends State<CreatePostTitle> {
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _formKey.currentState?.dispose(); // dispose the form
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return CreatePostPageLayout(
      title: l10n.newPost,
      page: _ScreenContent(
        formKey: _formKey,
      ),
      bottom: CreatePostBottomLayout(
        children: [
          Button(
            child: Text(
              l10n.continueText,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary
              ),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.of(context).pushNamed('/create-post/media');
              }
            }
          )
        ],
      )
    );
  }
}

class _ScreenContent extends StatelessWidget {
  final formKey;

  const _ScreenContent({
    required this.formKey,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Form(
      key: formKey,
      child: CreatePostContentLayout(
        children: [
          CreatePostTitleDesc(
            title: l10n.chooseTitleAndDesc,
            desc: l10n.chooseTitleAndDescSub
          ),
          const SizedBox(height: Sizing.inputSpacing,),
          TextInput(
            initialValue: CreatePostState.title,
            label: l10n.title,
            hint: l10n.titlePlaceholder,
            maxLength: 100,
            textInputAction: TextInputAction.next,
            onChanged: (v) {
              CreatePostState.title = v.trim();
            },
            validator: (value) {
              if (value == null || value.isEmpty || value.trim().isEmpty) {
                return l10n.emptyField(l10n.title);
              }
              return null;
            },
          ),
          const SizedBox(height: Sizing.inputSpacing,),
          TextInput(
            initialValue: CreatePostState.description,
            label: l10n.description,
            hint: l10n.descriptionPlaceholder,
            minLines: 3,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            maxLength: 512,
            onChanged: (v) {
              CreatePostState.description = v.trim();
            },
            validator: (value) {
              if (value == null || value.isEmpty || value.trim().isEmpty) {
                return l10n.emptyField(l10n.description);
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
