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
    this.removeFromHistoryTitle,
    this.removeFromHistoryContent,
  });

  final String? removeFromHistoryTitle;
  final String? removeFromHistoryContent;
  final TextEditingController searchController;

  final TimeZoneData? initTimeZoneData;
  final List<TimeZoneData>? customTimeZoneDataList;
  final Function(TimeZoneData initTimeZoneData)? onTimeZoneSelected;

  @override
  State<TimeZoneSelectWidget> createState() => _TimeZoneSelectWidgetState();
}

class _TimeZoneSelectWidgetState extends State<TimeZoneSelectWidget> {
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
            TimeZoneItemWidget(
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
                onLongPress: (timeZoneData) async {
                  final delete = await _handleLongPress(
                    context,
                    timeZoneData,
                    widget.removeFromHistoryTitle,
                    widget.removeFromHistoryContent,
                  );
                  if (delete) {
                    setState(() {});
                  }
                }),
          );
          return;
        }

        timeZoneListWidget.add(
          TimeZoneItemWidget(
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
            TimeZoneItemWidget(
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
                onLongPress: (timeZoneData) async {
                  final delete = await _handleLongPress(
                    context,
                    timeZoneData,
                    widget.removeFromHistoryTitle,
                    widget.removeFromHistoryContent,
                  );
                  if (delete) {
                    setState(() {});
                  }
                }),
          );
          continue;
        }

        timeZoneListWidget.add(
          TimeZoneItemWidget(
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
        TimeZoneItemWidget(
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
}

Future<bool> _handleLongPress(
  BuildContext context,
  TimeZoneData timeZoneData,
  String? removeFromHistoryTitle,
  String? removeFromHistoryContent,
) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(removeFromHistoryTitle ?? "Remove from history"),
          content: Text(removeFromHistoryContent ?? "After remove it from history, it will not be displayed in the top history list."),
          actions: <Widget>[
            TextButton(
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text(MaterialLocalizations.of(context).okButtonLabel),
              onPressed: () async {
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                final List<String> items = prefs.getStringList('selectedTimeZoneHistoryList') ?? [];
                items.remove(timeZoneData.name);
                await prefs.setStringList('selectedTimeZoneHistoryList', items);
                if (context.mounted) {
                  Navigator.of(context).pop(true);
                }
              },
            ),
          ],
        );
      });
}

//时区列表项
class TimeZoneItemWidget extends StatelessWidget {
  final TimeZoneData timeZoneData;
  final bool selected;
  final Function(TimeZoneData timeZoneData) onTap;
  final Function(TimeZoneData timeZoneData)? onLongPress;

  const TimeZoneItemWidget({
    super.key,
    required this.timeZoneData,
    required this.selected,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${timeZoneData.abbreviation}, UTC${TimezoneUtil.timeOffset2String(timeZoneData.offset)}${timeZoneData.isDst ? " DST" : ""}"),
      subtitle: Text(
        timeZoneData.name,
        style: const TextStyle(fontSize: 12),
      ),
      selected: selected,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      trailing: Visibility.maintain(
        visible: selected,
        child: const Icon(Icons.done_rounded),
      ),
      onTap: () {
        onTap.call(timeZoneData);
      },
      onLongPress: () {
        onLongPress?.call(timeZoneData);
      },
    );
  }
}
