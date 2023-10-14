import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/input/touchable/touchable.dart';

class SettingsItem extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const SettingsItem({
    Key? key,
    required this.onTap,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Touchable(
      onTap: onTap,
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: child,
        ),
      ),
    );
  }
}
