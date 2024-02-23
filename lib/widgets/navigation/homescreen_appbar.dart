import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/navigation/blur_parent.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class HomescreenAppbar extends StatelessWidget {
  final Widget child;
  final bool forceDisableBlur;
  final bool transparent;

  const HomescreenAppbar({
    super.key,
    required this.child,
    this.forceDisableBlur = false,
    this.transparent = false
  });

  @override
  Widget build(BuildContext context) {
    return BlurParent(
      height: MediaQuery.of(context).padding.top + Sizing.appbarHeight,
      forceDisableBlur: forceDisableBlur,
      blurColor: transparent ? Theme.of(context).colorScheme.inverseSurface.withOpacity(0.75) : null,
      noBlurColor: transparent ? Theme.of(context).colorScheme.surface : null,
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: MediaQuery.of(context).padding.top),
        child: child,
      ),
    );
  }
}
