import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart';

class TimeOfDayAndTimezone {
  const TimeOfDayAndTimezone({
    required this.offsetInHours,
    required this.type,
    required this.timeOfDay,
    required this.timezone,
  });
  final TimeOfDay timeOfDay;
  final TimeZone? timezone;
  final int? offsetInHours;
  final int type;

  // final TimeZone? timeZone;
}

