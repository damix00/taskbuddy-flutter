import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/unclickable.dart';

class MessageScreenOverlay extends StatelessWidget {
  final bool show;
  final VoidCallback onDismiss;

  const MessageScreenOverlay({
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
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black.withOpacity(0.75),
          child: GestureDetector(
            onTap: onDismiss,
          ),
        ),
      ),
    );
  }
}
