import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsets padding;

  const SettingsSection({
    Key? key,
    required this.title,
    required this.children,
    this.padding = const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
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
        ...children
      ],
    );
  }
}

class SettingsDivider extends StatelessWidget {
  const SettingsDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Theme.of(context).colorScheme.outline,
      height: 1,
      thickness: 1,
    );
  }
}
