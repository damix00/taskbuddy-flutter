import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/posts/post_results_response.dart';
import 'package:taskbuddy/screens/chat_screen.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/ui/platforms/bottom_sheet.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ComposeMessageSheet extends StatelessWidget {
  final PostResultsResponse post;
  final double height;

  const ComposeMessageSheet({Key? key, required this.post, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: height,
        child: BottomSheetBase(
          backgroundColor: Theme.of(context).colorScheme.background,
          topBarColor: Theme.of(context).colorScheme.surface,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          scrollable: false,
          children: [
            Container(
              height: Sizing.appbarHeight,
              width: double.infinity,
              color: Theme.of(context).colorScheme.surface,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Touchable(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Icon(Icons.close),
                    ),
                  ),
                  Expanded(
                    child: ChatScreenAppbar(
                      profilePicture: post.user.profilePicture,
                      title: post.title,
                      price: post.price.toString(),
                      firstName: post.user.firstName,
                      lastName: post.user.lastName
                    ),
                  ),
                ],
              )
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                l10n.initiateConversation,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            SizedBox(height: height - Sizing.appbarHeight - 128 - MediaQuery.of(context).padding.bottom,),
            Container(
              height: 44,
              width: MediaQuery.of(context).size.width - 32,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text input
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: l10n.typeAMessage,
                          hintStyle: Theme.of(context).textTheme.labelMedium,
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  // Send button
                  Touchable(
                    onTap: () => Navigator.of(context).pop(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.send,
                            size: 22,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    )
                  ),
                ],
              ),
            )
          ]
        ),
      ),
    );
  }
}