import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/slim_button.dart';
import 'package:taskbuddy/widgets/input/with_state/text_inputs/text_input.dart';
import 'package:taskbuddy/widgets/navigation/blur_parent.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ReportType {
  user,
  post,
  review
}

class ReportDialog extends StatelessWidget {
  final String UUID;
  final ReportType type;

  const ReportDialog({
    super.key,
    required this.UUID,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return BlurParent(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.report,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.reportDesc,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextInput(
              hint: l10n.reportPlaceholder,
              maxLines: 3,
              maxLength: 512,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SlimButton(
                    type: ButtonType.outlined,
                    child: Text(l10n.cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SlimButton(
                    child: ButtonText(l10n.report),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}