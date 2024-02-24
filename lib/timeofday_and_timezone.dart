import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart';

class TimeOfDayAndTimeZone {
  const TimeOfDayAndTimeZone({
    required this.offsetInHours,
    required this.type,
    required this.timeOfDay,
    required this.timeZone,
  });

  final TimeOfDay timeOfDay;
  final String? timeZone;
  final int? offsetInHours;
  final int? type;

  // final TimeZone? timeZone;

  @override
  String toString() {
    return 'TimeOfDayAndTimeZone{timeOfDay: $timeOfDay, timeZone: $timeZone, offsetInHours: $offsetInHours, type: $type}';
  }
}
