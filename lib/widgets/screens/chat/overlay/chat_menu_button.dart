import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';

class ChatMenuButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final IconData icon;

  const ChatMenuButton({
    Key? key,
    required this.onTap,
    required this.text,
    required this.icon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Touchable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(4)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium
            ),
            Icon(
              icon,
              color: Theme.of(context).colorScheme.onBackground,
              size: 20
            ),
          ],
        ),
      ),
    );
  }
}