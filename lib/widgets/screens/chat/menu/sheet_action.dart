import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';

class SheetAction extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;

  const SheetAction({
    Key? key,
    required this.onPressed,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Touchable(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            const SizedBox(width: 16),
            Text(label),
          ],
        ),
      ),
    );
  }
}