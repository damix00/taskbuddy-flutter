import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/ui/platforms/scrollbar_scroll_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class VerifyPhoneNumber extends StatelessWidget {
  const VerifyPhoneNumber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return ScrollbarSingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.verifyPhoneNumber,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.verifyPhoneNumberDesc,
                    style: Theme.of(context).textTheme.bodyMedium
                  ),
                ],
              ),
              const SizedBox(height: 24,),
              Button(
                child: Text(
                  l10n.continueText,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                onPressed: () {
                  OverlaySupportEntry.of(context)!.dismiss();
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}
