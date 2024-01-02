import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final double? padding;
  final Color? color;

  const CustomDivider({Key? key, this.padding, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding != null ? padding! / 2 : 0),
      child: Divider(
        color: color ?? Theme.of(context).colorScheme.surfaceVariant,
        thickness: 1,
      ),
    );
  }
}

class CustomVerticalDivider extends StatelessWidget {
  final double? padding;
  final Color? color;

  const CustomVerticalDivider({Key? key, this.padding, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding != null ? padding! / 2 : 0),
      child: VerticalDivider(
        color: color ?? Theme.of(context).colorScheme.surfaceVariant,
        thickness: 1,
      ),
    );
  }
}
