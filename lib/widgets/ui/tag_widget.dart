import 'package:flutter/material.dart';
import 'package:taskbuddy/state/providers/tags.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';

class TagWidget extends StatelessWidget {
  final Tag tag;
  final bool selected;
  final Function(bool) onSelect;

  const TagWidget({
    Key? key,
    required this.tag,
    this.selected = false,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Touchable(
      onTap: () {
        onSelect(!selected);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(56),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        child: Text(
          tag.name,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      )
    );
  }
}