import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/navigation/blur_parent.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class HomescreenAppbar extends StatelessWidget {
  final Widget child;
  final bool forceDisableBlur;

  const HomescreenAppbar({required this.child, this.forceDisableBlur = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlurParent(
      height: MediaQuery.of(context).padding.top + Sizing.appbarHeight,
      forceDisableBlur: forceDisableBlur,
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: MediaQuery.of(context).padding.top),
        child: child,
      ),
    );
  }
}
