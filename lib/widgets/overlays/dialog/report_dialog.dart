import 'package:flutter/material.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/slim_button.dart';
import 'package:taskbuddy/widgets/input/with_state/text_inputs/text_input.dart';
import 'package:taskbuddy/widgets/navigation/blur_parent.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/overlays/loading_overlay.dart';
import 'package:taskbuddy/widgets/ui/feedback/snackbars.dart';

enum ReportType {
  user,
  post,
  review
}

class ReportDialog extends StatefulWidget {
  final String UUID;
  final ReportType type;

  const ReportDialog({
    super.key,
    required this.UUID,
    required this.type,
  });

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  String _report = "";

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
              onChanged: (String value) {
                _report = value;
              },
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
                    onPressed: () async {
                      if (_report.isEmpty) {
                        SnackbarPresets.error(
                          context,
                          l10n.emptyField(l10n.report)
                        );

                        return;
                      }

                      String token = (await AccountCache.getToken())!;

                      LoadingOverlay.showLoader(context);

                      bool res = false;

                      if (widget.type == ReportType.user) {
                        res = await Api.v1.accounts.report(token, widget.UUID, _report);
                      } else if (widget.type == ReportType.post) {
                        res = await Api.v1.posts.reportPost(token, widget.UUID, _report);
                      } else if (widget.type == ReportType.review) {
                        res = await Api.v1.reviews.reportReview(token, widget.UUID, _report);
                      }

                      LoadingOverlay.hideLoader(context);
                      if (!res) {
                        SnackbarPresets.error(
                          context,
                          l10n.somethingWentWrong
                        );
                      }
                      else {
                        Navigator.of(context).pop();
                        SnackbarPresets.show(context, text: l10n.successfullyReported);
                      }
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