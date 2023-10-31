import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/input/touchable/touchable.dart';

class RadioItem {
  final String title;
  final String? subtitle;

  RadioItem({
    required this.title,
    this.subtitle,
  });
}

class SettingsRadioContainer extends StatelessWidget {
  final Function onChanged;
  final int selected;
  final List<RadioItem> items;

  const SettingsRadioContainer({
    required this.onChanged,
    required this.selected,
    required this.items,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...items.map((e) {
          return Touchable(
            onTap: () => onChanged(items.indexOf(e)),
            child: Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.background,
              child: Row(
                children: [
                  Radio(
                    value: items.indexOf(e),
                    groupValue: selected,
                    onChanged: (value) => onChanged(value),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (e.subtitle != null)
                          Text(
                            e.subtitle!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        })
      ],
    );
  }
}