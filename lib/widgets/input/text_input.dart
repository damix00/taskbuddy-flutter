import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/input/touchable/touchable.dart';

class TextInput extends StatelessWidget {
  final String label;
  final String hint;
  final bool obscureText;
  final TextEditingController? controller;
  final double borderRadius;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final String? errorText;
  final String? tooltipText;
  final bool optional; // If true, shows grey optional text
  final void Function(String)? onChanged;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;

  const TextInput(
      {Key? key,
      required this.label,
      required this.hint,
      this.obscureText = false,
      this.borderRadius = 4,
      this.controller,
      this.textInputAction = TextInputAction.done,
      this.keyboardType = TextInputType.text,
      this.errorText,
      this.optional = false,
      this.onChanged,
      this.tooltipText,
      this.minLines,
      this.maxLines = 1,
      this.maxLength,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(obscureText);

    // This is for the tooltip
    final GlobalKey<TooltipState> tooltipKey = GlobalKey<TooltipState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add a row with the label and the optional text
        // If the tooltip text is specified, add a tooltip icon
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('$label ', style: Theme.of(context).textTheme.titleMedium),
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
                // Disable auto hide (1 day is more than enough)
                waitDuration: const Duration(days: 1),
                key: tooltipKey,
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
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          onChanged: onChanged,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          controller: controller,
          validator: validator,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 14,
          ),
          obscureText: obscureText,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          decoration: InputDecoration(
            errorText: errorText,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            hintText: hint,
            isDense: true,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.outline),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
      ],
    );
  }
}
