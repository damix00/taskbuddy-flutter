import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/input/touchable/touchable.dart';
import 'package:taskbuddy/widgets/ui/conditional_wrapper.dart';

class RadioItem {
  final String title;
  final String? subtitle;

  RadioItem({
    required this.title,
    this.subtitle,
  });
}

class RadioButtons extends StatelessWidget {
  final Function onChanged;
  final int selected;
  final List<RadioItem> items;

  const RadioButtons({
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
              padding: EdgeInsets.symmetric(
                vertical: e.subtitle != null ? 4 : 0
              ),
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
                          style: Theme.of(context).textTheme.bodyLarge,
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