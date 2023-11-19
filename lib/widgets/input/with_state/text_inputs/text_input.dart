import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taskbuddy/widgets/input/with_state/text_inputs/input_title.dart';

class TextInput extends StatelessWidget {
  final String? label;
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
  final String? initialValue;
  final Widget? prefix;
  final String? prefixText;

  const TextInput({
    Key? key,
    this.label,
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
    this.initialValue,
    this.validator,
    this.prefix,
    this.prefixText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add a row with the label and the optional text
        // If the tooltip text is specified, add a tooltip icon
        if (label != null) 
          InputTitle(title: label!, optional: optional, tooltipText: tooltipText),
        if (label != null) 
          const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
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
            prefix: prefix
              ?? (prefixText != null
                ? Text(
                  prefixText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                )
                : null
              ),
          ),
        ),
      ],
    );
  }
}
