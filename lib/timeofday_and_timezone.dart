import 'package:flutter/material.dart';

class TimeOfDayAndTimezone {
  const TimeOfDayAndTimezone({
    required this.offsetInHours,
    required this.type,
    required this.timeOfDay,
    required this.timezone,
  });

  final TimeOfDay timeOfDay;
  final String? timezone;
  final int? offsetInHours;
  final int type;
}
