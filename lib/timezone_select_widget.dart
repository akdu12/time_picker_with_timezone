// Copyright 2024 Charles Lee. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Future<List<Widget>> _buildTimeZoneWidgetList() async {
    final List<Widget> timeZoneListWidget = [];
    final List<Widget> timeZoneHistoryListWidget = [];

    //已选择过的历史数据
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> historyList = prefs.getStringList('selectedTimeZoneHistoryList') ?? [];

    if (widget.customTimeZoneDataList == null) {
      tz.timeZoneDatabase.locations.forEach((name, location) {
        final currentTimeZone = location.currentTimeZone;

        if (searchText.isNotEmpty && !name.toLowerCase().contains(searchText.toLowerCase()) && !currentTimeZone.abbreviation.toLowerCase().contains(searchText.toLowerCase())) {
          return;
        }

        if (widget.initTimeZoneData == TimeZoneData(name: name, abbreviation: currentTimeZone.abbreviation, offset: currentTimeZone.offset, isDst: currentTimeZone.isDst)) {
          return;
        }

        if (historyList.contains(name)) {
          timeZoneHistoryListWidget.add(
            _buildTimeZoneItemWidget(
              timeZoneData: TimeZoneData(
                name: name,
                abbreviation: currentTimeZone.abbreviation,
                offset: currentTimeZone.offset,
                isDst: currentTimeZone.isDst,
              ),
              selected: name == widget.initTimeZoneData?.name,
              onTap: (timeZoneData) {
                _handleSelect(timeZoneData);
              },
            ),
          );
          return;
        }

        timeZoneListWidget.add(
          _buildTimeZoneItemWidget(
            timeZoneData: TimeZoneData(
              name: name,
              abbreviation: currentTimeZone.abbreviation,
              offset: currentTimeZone.offset,
              isDst: currentTimeZone.isDst,
            ),
            selected: name == widget.initTimeZoneData?.name,
            onTap: (timeZoneData) {
              _handleSelect(timeZoneData);
            },
          ),
        );
      });
    } else {
      for (var element in widget.customTimeZoneDataList!) {
        if (searchText.isNotEmpty && !element.name.toLowerCase().contains(searchText.toLowerCase()) && !element.abbreviation.toLowerCase().contains(searchText.toLowerCase())) {
          continue;
        }

        if (widget.initTimeZoneData == element) {
          continue;
        }

        if (historyList.contains(element.name)) {
          timeZoneHistoryListWidget.add(
            _buildTimeZoneItemWidget(
              timeZoneData: TimeZoneData(
                name: element.name,
                abbreviation: element.abbreviation,
                offset: element.offset,
                isDst: element.isDst,
              ),
              selected: element.name == widget.initTimeZoneData?.name,
              onTap: (timeZoneData) {
                _handleSelect(timeZoneData);
              },
            ),
          );
          continue;
        }

        timeZoneListWidget.add(
          _buildTimeZoneItemWidget(
            timeZoneData: element,
            selected: element.name == widget.initTimeZoneData?.name,
            onTap: (timeZoneData) {
              _handleSelect(timeZoneData);
            },
          ),
        );
      }
    }

    if (widget.initTimeZoneData != null || historyList.isNotEmpty) {
      timeZoneListWidget.insert(0, const Divider());
    }

    if (historyList.isNotEmpty) {
      timeZoneListWidget.insertAll(0, timeZoneHistoryListWidget);
    }

    //如果有已选中数据，就添加到列表首位，无论搜索什么，都会显示在最上面
    if (widget.initTimeZoneData != null) {
      timeZoneListWidget.insert(
        0,
        _buildTimeZoneItemWidget(
          timeZoneData: widget.initTimeZoneData!,
          selected: true,
          onTap: (timeZoneData) {
            widget.onTimeZoneSelected?.call(timeZoneData);
          },
        ),
      );
    }

    return timeZoneListWidget;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      width: 1000, //这样会被限制在最宽
      child: FutureBuilder<List<Widget>>(
        future: _buildTimeZoneWidgetList(),
        builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return Scrollbar(
            child: ListView(
              children: snapshot.data!,
            ),
          );
        },
      ),
    );
  }

  //选中后返回并存储选中历史
  void _handleSelect(TimeZoneData timeZoneData) async {
    widget.onTimeZoneSelected?.call(timeZoneData);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> items = prefs.getStringList('selectedTimeZoneHistoryList') ?? [];
    if (!items.contains(timeZoneData.name)) {
      items.add(timeZoneData.name);
      await prefs.setStringList('selectedTimeZoneHistoryList', items);
    }
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
