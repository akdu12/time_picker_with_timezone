import 'package:flutter/material.dart';

class TimeWithTimeZone {
  const TimeWithTimeZone({
    required this.timeOfDay,
    required this.timeZoneType,
    required this.timeZoneData,
  });

  final TimeOfDay timeOfDay;

  final TimeZoneType? timeZoneType;

  final TimeZoneData? timeZoneData;

  @override
  String toString() {
    return 'TimeWithTimeZone{timeOfDay: $timeOfDay, type: $timeZoneType, timeZoneData: $timeZoneData}';
  }
}

//防止后期替换TimeZone库，在这里自定义一个
class TimeZoneData {
  const TimeZoneData({
    required this.name,
    required this.abbreviation,
    required this.offset,
    required this.isDst,
  });

  //name, eg: "Asia/Shanghai"
  final String name;

  //abbreviation, eg: "CST"
  final String abbreviation;

  //offsetInHours, eg: 8
  final int offset;

  //Is summer time
  final bool isDst;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeZoneData && other.name == name && other.abbreviation == abbreviation && other.offset == offset && other.isDst == isDst;
  }

  @override
  int get hashCode => name.hashCode ^ abbreviation.hashCode ^ offset.hashCode ^ isDst.hashCode;

  @override
  String toString() {
    return 'TimeZoneData{name: $name, abbreviation: $abbreviation, offsetInHours: $offset, isDst: $isDst}';
  }
}

enum TimeZoneType {
  fixedTime(0),
  timeZoneTime(1);

  final int value;

  const TimeZoneType(this.value);
}

enum TimeZoneShowType {
  abbreviation,
  name,
  nameAndOffset,
  abbreviationAndOffset,
}
