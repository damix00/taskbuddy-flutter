import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/input/with_state/input_title.dart';

class TBSlider extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String unit;
  final double value;
  final double min;
  final double max;

  final Function(double) onChanged;

  const TBSlider({
    Key? key,
    required this.title,
    this.subtitle,
    this.unit = '',
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputTitle(
          title: title,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4,),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
        const SizedBox(height: 8,),
        Row(
          children: [
            Text(
              // remove decimals
              "${min.toStringAsFixed(0)}$unit",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Expanded(
              child: Slider(
                value: value,
                min: min,
                max: max,
                onChanged: onChanged,
                label: '${value.round()} $unit', // Show current value
              ),
            ),
            Text(
              "${max.toStringAsFixed(0)}$unit",
              style: Theme.of(context).textTheme.labelMedium,
            )
          ],
        ),
      ],
    );
  }
}