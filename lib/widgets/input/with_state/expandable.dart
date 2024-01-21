import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Expandable extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final bool initiallyExpanded;
  final int maxLines;

  const Expandable({
    super.key,
    required this.text,
    this.style,
    this.initiallyExpanded = false,
    this.maxLines = 3,
  });

  @override
  _ExpandableState createState() => _ExpandableState();
}

class _ExpandableState extends State<Expandable> {
  bool _expanded = false;

  @override
  void initState() {
    super.initState();

    _expanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Touchable(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.text,
            style: widget.style,
            maxLines: _expanded ? null : widget.maxLines,
            overflow: _expanded ? null : TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 8),

          Text(
            _expanded ? l10n.readMore : l10n.seeLess,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            )
          )
        ],
      ),
    );
  }
}
