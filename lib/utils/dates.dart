import 'dart:ui';

import 'package:intl/intl.dart';

class Dates {
  static String formatDate(DateTime date, {bool showTime = true}) {
    return '${DateFormat.yMMMd().format(date.toLocal())}${showTime ? " ${DateFormat.Hm().format(date.toLocal())}" : ""}';
  }

  static String timeAgo(DateTime date, Locale locale) {
    final now = DateTime.now();
    // TODO: Fix timezones
    var d = date.add(const Duration(hours: 1));
    final difference = now.difference(d);

    if (difference.inSeconds < 0) {
      if (difference.inSeconds > -60) {
        return Intl.message('in a moment', name: 'timeAgo', locale: locale.toString());
      } else if (difference.inMinutes > -60) {
        final minutes = difference.inMinutes.abs();
        return Intl.plural(
          minutes,
          one: 'in $minutes minute',
          other: 'in $minutes minutes',
          name: 'timeAgo',
          locale: locale.toString(),
        );
      } else if (difference.inHours > -24) {
        final hours = difference.inHours.abs();
        return Intl.plural(
          hours,
          one: 'in $hours hour',
          other: 'in $hours hours',
          name: 'timeAgo',
          locale: locale.toString(),
        );
      } else if (difference.inDays > -7) {
        final days = difference.inDays.abs();
        return Intl.plural(
          days,
          one: 'in $days day',
          other: 'in $days days',
          name: 'timeAgo',
          locale: locale.toString(),
        );
      } else if (difference.inDays > -30) {
        final weeks = (difference.inDays.abs() / 7).round();
        return Intl.plural(
          weeks,
          one: 'in $weeks week',
          other: 'in $weeks weeks',
          name: 'timeAgo',
          locale: locale.toString(),
        );
      } else if (difference.inDays > -365) {
        final months = (difference.inDays.abs() / 30).round();
        return Intl.plural(
          months,
          one: 'in $months month',
          other: 'in $months months',
          name: 'timeAgo',
          locale: locale.toString(),
        );
      } else {
        final years = (difference.inDays.abs() / 365).round();
        return Intl.plural(
          years,
          one: 'in $years year',
          other: 'in $years years',
          name: 'timeAgo',
          locale: locale.toString(),
        );
      }
    }

    if (difference.inSeconds < 60) {
      return Intl.message('a moment ago', name: 'timeAgo', locale: locale.toString());
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return Intl.plural(
        minutes,
        one: '$minutes minute ago',
        other: '$minutes minutes ago',
        name: 'timeAgo',
        locale: locale.toString(),
      );
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return Intl.plural(
        hours,
        one: '$hours hour ago',
        other: '$hours hours ago',
        name: 'timeAgo',
        locale: locale.toString(),
      );
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return Intl.plural(
        days,
        one: '$days day ago',
        other: '$days days ago',
        name: 'timeAgo',
        locale: locale.toString(),
      );
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).round();
      return Intl.plural(
        weeks,
        one: '$weeks week ago',
        other: '$weeks weeks ago',
        name: 'timeAgo',
        locale: locale.toString(),
      );
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).round();
      return Intl.plural(
        months,
        one: '$months month ago',
        other: '$months months ago',
        name: 'timeAgo',
        locale: locale.toString(),
      );
    } else {
      final years = (difference.inDays / 365).round();
      return Intl.plural(
        years,
        one: '$years year ago',
        other: '$years years ago',
        name: 'timeAgo',
        locale: locale.toString(),
      );
    }
  }
}