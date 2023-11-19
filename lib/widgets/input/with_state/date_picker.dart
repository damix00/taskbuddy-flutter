import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';

class DatePicker extends StatelessWidget {
  final String label;
  final DateTime value;
  final DateTime? minDate;
  final DateTime? maxDate;
  final Function(DateTime) onChanged;

  const DatePicker({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.minDate,
    this.maxDate,
  }) : super(key: key);

  void _showCupertinoDialog(BuildContext context, { required Widget child }) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  void _handleClick(BuildContext context) async {
    var _minDate = minDate ?? DateTime.now();
    var _maxDate = maxDate ?? DateTime.now().add(const Duration(days: 365)); // 1 year from now

    if (Platform.isAndroid) {
      // Date and time picker
      var date = await showDatePicker(
        context: context,
        initialDate: value,
        firstDate: _minDate,
        lastDate: _maxDate,
      );

      if (date != null) {
        var time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(value),
        );

        if (time != null) {
          onChanged(DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute
          ));
        }
      }
    }

    else {
      // iOS date picker
      _showCupertinoDialog(
          context,
          child: CupertinoDatePicker(
            initialDateTime: value,
            use24hFormat: true,
            minimumDate: _minDate,
            maximumDate: _maxDate,
            onDateTimeChanged: (DateTime date) {
              onChanged(date);
            },
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8,),
        Touchable(
          onTap: () {
            _handleClick(context); 
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 1
              ),
              borderRadius: BorderRadius.circular(4)
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today_outlined),
                const SizedBox(width: 8,),
                Text(
                  // Date, Month, Year, HH:MM
                  '${DateFormat.yMMMd().format(value)} ${DateFormat.Hm().format(value)}',
                  style: Theme.of(context).textTheme.bodyMedium
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

}