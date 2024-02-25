// Copyright 2024 Charles Lee. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:time_picker_with_timezone/time_with_timezone.dart';

/// Convert a time offset in hours to a string representation
/// eg: -1 -> "-01:00"
class TimezoneUtil {
  static String timeOffset2String(int? offset) {
    if (offset == null) return "";
    String offsetStr = "";

    int offsetInHours = offset ~/ 1000 ~/ 3600;
    if (offsetInHours >= 10) {
      offsetStr += "+$offsetInHours";
    } else if (offsetInHours >= 0) {
      offsetStr = "+0$offsetInHours";
    } else if (offsetInHours > -10) {
      offsetStr = "-0${-offsetInHours}";
    } else {
      offsetStr = "$offsetInHours";
    }

    offsetStr += ":00";

    return offsetStr;
  }

  static String timeZoneString(TimeZoneData timeZoneData, TimeZoneShowType timeZoneShowType) {
    String timeZoneStr = "";
    switch (timeZoneShowType) {
      case TimeZoneShowType.name:
        timeZoneStr = timeZoneData.name;
        break;
      case TimeZoneShowType.nameAndOffset:
        timeZoneStr = "${timeZoneData.name}, UTC${TimezoneUtil.timeOffset2String(timeZoneData.offset)}";
        break;
      case TimeZoneShowType.abbreviation:
        timeZoneStr = timeZoneData.abbreviation;
        break;
      case TimeZoneShowType.abbreviationAndOffset:
        timeZoneStr = "${timeZoneData.abbreviation}, UTC${TimezoneUtil.timeOffset2String(timeZoneData.offset)}";
        break;
    }
    return timeZoneStr;
  }
}
