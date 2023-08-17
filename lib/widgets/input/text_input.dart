import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextInput extends StatelessWidget {
  final String label;
  final String hint;
  final bool obscureText;
  final TextEditingController? controller;
  final double borderRadius;

  const TextInput({Key? key, required this.label, required this.hint, this.obscureText = false, this.borderRadius = 4, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          height: 40,
          child: TextField(
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 14,
            ),
            obscureText: obscureText,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[500],
              ),
              // fillColor: Theme.of(context).colorScheme.background,
              fillColor: Colors.red,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}