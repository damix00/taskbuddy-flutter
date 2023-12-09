import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class ValueDisplay extends StatelessWidget {
  final String title;
  final String value;

  const ValueDisplay({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: Sizing.inputSpacing / 2),
            child: Text(
              title,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.labelMedium,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          )
        ],
      ),
    );
  }
}