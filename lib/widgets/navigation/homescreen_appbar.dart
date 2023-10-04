import 'package:flutter/material.dart';

class HomescreenAppbar extends StatelessWidget {
  final List<Widget> children;

  const HomescreenAppbar({required this.children, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 56,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        ),
      )
    );
  }
}
