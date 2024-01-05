import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/navigation/blur_parent.dart';

class MenuSheet extends StatelessWidget {
  const MenuSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;

    return BlurParent(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: padding.top),
            Text('Bottom sheet'),
            SizedBox(height: padding.bottom),
          ],
        ),
      )
    );
  }
}