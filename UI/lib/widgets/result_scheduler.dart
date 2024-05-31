import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum SchedulerType {
  light,
  watering,
}

class ResultScheduler extends StatelessWidget {
  const ResultScheduler({
    super.key,
    required this.firstTitle,
    required this.firstResult,
    required this.secondTitle,
    required this.secondResult,
  });

  final String firstTitle;
  final TimeOfDay firstResult;
  final String secondTitle;
  final TimeOfDay secondResult;

  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(firstTitle),
            Text(secondTitle),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formatTimeOfDay(firstResult)),
            Text(formatTimeOfDay(secondResult)),
          ],
        ),
      ],
    );
  }
}
