// Copyright 2024 Charles Lee. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:time_picker_with_timezone/timezone_util.dart';

// import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimeZoneSelectWidget extends StatefulWidget {
  const TimeZoneSelectWidget({
    required this.searchController,
    super.key,
    this.initTimeZone,
    this.initOffsetInHours,
    this.onTimeZoneSelected,
  });

  final TextEditingController searchController;
  final String? initTimeZone;
  final int? initOffsetInHours;

  final Function(String timeZone, int timeOffset)? onTimeZoneSelected;

  @override
  State<TimeZoneSelectWidget> createState() => _TimeZoneSelectWidgetState();
}

class _TimeZoneSelectWidgetState extends State<TimeZoneSelectWidget> {
  final visualDensity = const VisualDensity(horizontal: -4, vertical: -4);
  var searchText = "";

  void searchListener() {
    // print(widget.searchController.text);
    searchText = widget.searchController.text;
    setState(() {});
  }

  @override
  void initState() {
    tz.initializeTimeZones();
    widget.searchController.addListener(searchListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.searchController.removeListener(searchListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> timezoneListWidget = [];

    tz.timeZoneDatabase.locations.forEach((name, location) {
      if (searchText.isNotEmpty && !name.toLowerCase().contains(searchText.toLowerCase())) {
        return;
      }

      final offsetInSeconds = location.currentTimeZone.offset ~/ 1000;
      final offsetInHours = offsetInSeconds ~/ 3600;
      final isDst = location.currentTimeZone.isDst;
      final abbreviation = location.currentTimeZone.abbreviation;

      final offsetStr = TimezoneUtil.timeOffset2String(offsetInHours);

      timezoneListWidget.add(
        ListTile(
          title: Text("$abbreviation, UTC$offsetStr${isDst ? " DST" : ""}"),
          subtitle: Text(
            name,
            style: const TextStyle(fontSize: 12),
          ),
          selected: name == widget.initTimeZone,
          visualDensity: visualDensity,
          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          trailing: Visibility.maintain(
            visible: name == widget.initTimeZone,
            child: const Icon(Icons.done_rounded),
          ),
          onTap: () {
            widget.onTimeZoneSelected?.call(name, offsetInHours);
          },
        ),
      );
    });
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      width: 1000, //这样会被限制在最宽
      child: Scrollbar(
        child: ListView(
          children: timezoneListWidget,
        ),
      ),
    );
    // return SingleChildScrollView(
    //   child: ListBody(
    //     children: timezoneListWidget,
    //   ),
    // );
  }
}
