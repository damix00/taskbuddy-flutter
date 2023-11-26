import 'package:flutter/material.dart';
import 'package:taskbuddy/state/providers/tags.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      child: AnimatedScale(
        scale: selected ? 0.9: 1,
        duration: const Duration(milliseconds: 50),
        child: Container(
          decoration: BoxDecoration(
            color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(56),
            border: Border.all(
              color: selected ? Colors.transparent : Theme.of(context).colorScheme.outline,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          child: Text(
            tag.translations[AppLocalizations.of(context)!.localeName.toLowerCase()] ?? tag.translations['en']!,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: selected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      )
    );
  }
}