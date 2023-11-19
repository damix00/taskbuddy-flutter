import 'package:flutter/material.dart';
import 'package:taskbuddy/screens/create_post/page_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/screens/create_post/title_desc.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/with_state/date_picker.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class CreatePostDatePrice extends StatelessWidget {
  const CreatePostDatePrice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return CreatePostPageLayout(
      title: l10n.newPost,
      page: const _PageContent(),
      bottom: CreatePostBottomLayout(
        children: [
          Button(
            child: ButtonText(l10n.continueText),
            onPressed: () {},
          ),
        ]
      )
    );
  }
}

class _PageContent extends StatefulWidget {
  const _PageContent({Key? key}) : super(key: key);

  @override
  State<_PageContent> createState() => _PageContentState();
}

class _PageContentState extends State<_PageContent> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return CreatePostContentLayout(
      children: [
        CreatePostTitleDesc(
          title: l10n.selectStartEnd,
          desc: l10n.selectStartEndDesc,
        ),
        const SizedBox(height: Sizing.formSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DatePicker(
              label: l10n.startDate,
              value: _startDate,
              maxDate: _endDate,
              onChanged: (value) {
                setState(() {
                  _startDate = value;
                });
              }
            ),
            DatePicker(
              label: l10n.endDate,
              value: _endDate,
              minDate: _startDate,
              onChanged: (value) {
                setState(() {
                  _endDate = value;
                });
              }
            ),
          ],
        ),
      ],
    );
  }
}
