import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';

// Link text component
// Text that is clickable and looks like a link
class LinkText extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool disabled;

  const LinkText({Key? key, this.disabled = false, required this.text, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Touchable(
      onTap: onTap,
      disabled: disabled,
      child: Text(text, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.inversePrimary, fontWeight: FontWeight.w900)),
    );
  }
}