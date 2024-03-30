import 'package:flutter/material.dart';
import 'package:taskbuddy/utils/haptic_feedback.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/navigation/blur_parent.dart';

// This is just a button with a smaller height, used more for social functions
class SlimButton extends StatelessWidget {
  final Widget child;
  final ButtonType type;
  final VoidCallback onPressed;
  final bool disabled;

  const SlimButton({Key? key, required this.onPressed, required this.child, this.type = ButtonType.primary, this.disabled = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Button(
      disabled: disabled,
      onPressed: onPressed,
      type: type,
      height: 32,
      radius: 4,
      child: child,
    );
  }
}

// This is an even smaller button, used for feed actions
class FeedSlimButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const FeedSlimButton({Key? key, required this.onPressed, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Touchable(
      onTap: () {
        HapticFeedbackUtils.lightImpact(context);
        onPressed();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: BlurParent(
          blurColor: Colors.transparent,
          noBlurColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: child,
          ),
        ),
      )
    );
  }
}
