import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';

class SlimButton extends StatelessWidget {
  final Widget child;
  final ButtonType type;
  final VoidCallback onPressed;

  const SlimButton({Key? key, required this.onPressed, required this.child, this.type = ButtonType.primary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      type: type,
      height: 32,
      radius: 4,
      child: child,
    );
  }
}

class FeedSlimButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const FeedSlimButton({Key? key, required this.onPressed, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Touchable(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: child,
      )
    );
  }
}
