import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/unclickable.dart';
import 'package:taskbuddy/widgets/navigation/blur_parent.dart';

class ChatScreenOverlay extends StatelessWidget {
  final bool show;
  final VoidCallback onDismiss;

  const ChatScreenOverlay({
    Key? key,
    required this.show,
    required this.onDismiss
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: show ? 1 : 0,
      child: Unclickable(
        enabled: show,
        child: GestureDetector(
          onTap: onDismiss,
          child: BlurParent(
            blurColor: Theme.of(context).colorScheme.background.withOpacity(0.5),
            noBlurColor: Colors.black.withOpacity(0.75),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              // color: Colors.black.withOpacity(0.75),
            ),
          ),
        ),
      ),
    );
  }
}
