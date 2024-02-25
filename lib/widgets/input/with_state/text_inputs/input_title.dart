import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';

// This is a widget for the title of an input field
class InputTitle extends StatelessWidget {
  final String title;
  final bool optional;
  final String? tooltipText;

  const InputTitle({
    required this.title,
    this.optional = false,
    this.tooltipText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<TooltipState> tooltipKey = GlobalKey<TooltipState>();

    return Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
      Text('$title ', style: Theme.of(context).textTheme.titleMedium),
      if (optional)
        Text(
          '${AppLocalizations.of(context)!.optional} ',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          )
        ),
      if (tooltipText != null)
        Tooltip(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          message: tooltipText,
          // Disable auto hide
          waitDuration: Duration.zero,
          key: tooltipKey,
          triggerMode: TooltipTriggerMode.manual,
          child: Touchable(
            onTap: () {
              // Show the tooltip on tap
              tooltipKey.currentState?.ensureTooltipVisible();
            },
            child: Icon(
              Icons.info_outline,
              size: 18,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        )
      ]
    );
  }
}
