import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';

class RadioItem {
  final String title;
  final String? subtitle;

  RadioItem({
    required this.title,
    this.subtitle,
  });
}

class RadioButtons extends StatelessWidget {
  final Function(int) onChanged;
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
          int index = items.indexOf(e);
          
          return RadioButtonItem(
            onChanged: onChanged,
            selected: selected,
            item: e,
            index: index,
          );
        })
      ],
    );
  }
}

class RadioButtonItem extends StatelessWidget {
  final Function(int) onChanged;
  final int selected;
  final RadioItem item;
  final int index;

  const RadioButtonItem({
    Key? key,
    required this.onChanged,
    required this.selected,
    required this.item,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Touchable(
      onTap: () => onChanged(index),
      child: Container(
        width: double.infinity,
        color: Theme.of(context).colorScheme.background,
        child: Row(
          children: [
            Radio(
              value: index,
              groupValue: selected,
              onChanged: (value) => onChanged(value!),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (item.subtitle != null)
                    Text(
                      item.subtitle!,
                      style: Theme.of(context).textTheme.labelMedium
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
