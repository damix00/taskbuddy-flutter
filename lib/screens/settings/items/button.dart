import 'package:flutter/material.dart';
import 'package:taskbuddy/screens/settings/items/item.dart';

class SettingsButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? iconColor;

  const SettingsButton({
    required this.child,
    required this.onTap,
    this.icon,
    this.iconColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsItem(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            if (icon != null) Icon(icon, color: iconColor ?? Theme.of(context).colorScheme.onSurfaceVariant),
            if (icon != null) const SizedBox(width: 12),
            child,
          ],
        ),
      ),
    );
  }
}
