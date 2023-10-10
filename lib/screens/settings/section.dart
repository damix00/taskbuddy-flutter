import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsets padding;

  const SettingsSection({
    Key? key,
    required this.title,
    required this.children,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: padding,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: Theme.of(context).textTheme.displaySmall
              ),
            ),
          ),
        ...children,
      ],
    );
  }
}