// Copyright 2024 Charles Lee. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:time_picker_with_timezone/time_with_timezone.dart';
import 'package:time_picker_with_timezone/timezone_util.dart';

// import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimeZoneSelectWidget extends StatefulWidget {
  const TimeZoneSelectWidget({
    required this.searchController,
    super.key,
    this.initTimeZoneData,
    this.customTimeZoneDataList,
    this.onTimeZoneSelected,
  });

  final TextEditingController searchController;

  final TimeZoneData? initTimeZoneData;
  final List<TimeZoneData>? customTimeZoneDataList;
  final Function(TimeZoneData initTimeZoneData)? onTimeZoneSelected;

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

    if (widget.customTimeZoneDataList == null) {
      tz.timeZoneDatabase.locations.forEach((name, location) {
        final currentTimeZone = location.currentTimeZone;

        if (searchText.isNotEmpty && !name.toLowerCase().contains(searchText.toLowerCase()) && !currentTimeZone.abbreviation.toLowerCase().contains(searchText.toLowerCase())) {
          return;
        }

        final isDst = currentTimeZone.isDst;

        timezoneListWidget.add(
          _buildTimeZoneItemWidget(
            timeZoneData: TimeZoneData(
              name: name,
              abbreviation: currentTimeZone.abbreviation,
              offset: currentTimeZone.offset,
              isDst: currentTimeZone.isDst,
            ),
            selected: name == widget.initTimeZoneData?.name,
            onTap: (timeZoneData) {
              widget.onTimeZoneSelected?.call(timeZoneData);
            },
          ),
        );
      });
    } else {
      for (var element in widget.customTimeZoneDataList!) {
        if (searchText.isNotEmpty && !element.name.toLowerCase().contains(searchText.toLowerCase()) && !element.abbreviation.toLowerCase().contains(searchText.toLowerCase())) {
          continue;
        }
        timezoneListWidget.add(
          _buildTimeZoneItemWidget(
            timeZoneData: element,
            selected: element.name == widget.initTimeZoneData?.name,
            onTap: (timeZoneData) {
              widget.onTimeZoneSelected?.call(timeZoneData);
            },
          ),
        );
      }
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      width: 1000, //这样会被限制在最宽
      child: Scrollbar(
        child: ListView(
          children: timezoneListWidget,
        ),
      ),
    );
  }

  //创建时区列表项
  Widget _buildTimeZoneItemWidget({required TimeZoneData timeZoneData, required bool selected, required Function(TimeZoneData timeZoneData) onTap}) {
    return ListTile(
      title: Text("${timeZoneData.abbreviation}, UTC${TimezoneUtil.timeOffset2String(timeZoneData.offset)}${timeZoneData.isDst ? " DST" : ""}"),
      subtitle: Text(
        timeZoneData.name,
        style: const TextStyle(fontSize: 12),
      ),
      selected: selected,
      visualDensity: visualDensity,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      trailing: Visibility.maintain(
        visible: selected,
        child: const Icon(Icons.done_rounded),
      ),
      onTap: () {
        onTap.call(timeZoneData);
      },
    );
  }
}
