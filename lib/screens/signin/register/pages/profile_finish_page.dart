import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/appbar/blur_appbar.dart';
import 'package:taskbuddy/widgets/input/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/screens/screen_title.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class ProfileFinishPage extends StatelessWidget {
  const ProfileFinishPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: ScrollbarSingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizing.horizontalPadding,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: max(MediaQuery.of(context).size.height, 800),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ScreenTitle(
                      title: 'test',
                      description: 'desc'),
                  const SizedBox(height: Sizing.formSpacing),
                ],
              ),
            ),
          ),
        ));
  }
}