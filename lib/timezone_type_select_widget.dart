// Copyright 2024 Charles Lee. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:time_picker_with_timezone/time_with_timezone.dart';
import 'package:time_picker_with_timezone/timezone_select_widget.dart';
import 'package:time_picker_with_timezone/timezone_util.dart';

class TimeZoneTypeSelectWidget extends StatefulWidget {
  const TimeZoneTypeSelectWidget({
    super.key,
    this.timeZoneShowType,
    this.initTimeZoneType,
    this.initTimeZoneData,
    this.customTimeZoneDataList,
    this.fixedTimeTitle,
    this.fixedTimeSubTitle,
    this.timeZoneTimeTitle,
    // this.timezoneTimeSubTitle,

    this.timeZoneSearchIcon,
    this.timeZoneSearchHintStyle,
    this.timeZoneSearchHint,
    this.onTimeZoneTypeSelected,
  });

  final TimeZoneShowType? timeZoneShowType;
  final TimeZoneType? initTimeZoneType;
  final TimeZoneData? initTimeZoneData;
  final List<TimeZoneData>? customTimeZoneDataList;

  final String? fixedTimeTitle;
  final String? fixedTimeSubTitle;
  final String? timeZoneTimeTitle;

  // final String? timezoneTimeSubTitle;

  final Icon? timeZoneSearchIcon;
  final String? timeZoneSearchHint;
  final TextStyle? timeZoneSearchHintStyle;

  final Function(TimeZoneType timeZoneType, TimeZoneData? timeZoneData)? onTimeZoneTypeSelected;

  @override
  State<TimeZoneTypeSelectWidget> createState() => _TimeZoneTypeSelectWidgetState();
}

class _TimeZoneTypeSelectWidgetState extends State<TimeZoneTypeSelectWidget> {
  final visualDensity = const VisualDensity(horizontal: -2, vertical: 0);
  final contentPadding = const EdgeInsets.only(left: 20, right: 16);
  final titleTextStyle = const TextStyle(fontSize: 12);

  final searchController = TextEditingController();

  // String? timezoneTimeSubTitle;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('TimezoneTypeSelectWidget build');
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          ListTile(
            title: Text(widget.fixedTimeTitle ?? 'Fixed time'),
            subtitle: Text(
              widget.fixedTimeSubTitle ?? 'Does not vary by time zone',
              style: titleTextStyle,
            ),
            selected: widget.initTimeZoneType == TimeZoneType.fixedTime,
            visualDensity: visualDensity,
            contentPadding: contentPadding,
            leading: Visibility.maintain(
              visible: widget.initTimeZoneType == TimeZoneType.fixedTime,
              child: const Icon(Icons.done_rounded),
            ),
            onTap: () {
              widget.onTimeZoneTypeSelected?.call(TimeZoneType.fixedTime, null);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text(widget.timeZoneTimeTitle ?? 'Time zone time'),
            subtitle: widget.initTimeZoneData != null
                ? Text(
                    TimezoneUtil.timeZoneString(widget.initTimeZoneData!, widget.timeZoneShowType!),
                    style: titleTextStyle,
                  )
                : null,
            selected: widget.initTimeZoneType == TimeZoneType.timeZoneTime,
            visualDensity: visualDensity,
            contentPadding: contentPadding,
            leading: Visibility.maintain(
              visible: widget.initTimeZoneType == TimeZoneType.timeZoneTime,
              child: const Icon(Icons.done_rounded),
            ),
            onTap: () {
              showDialog(
                context: context,
                barrierColor: Colors.transparent, //多个barrier叠加后背景太深，不好看
                builder: (BuildContext context) {
                  return AlertDialog(
                    insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                    iconPadding: const EdgeInsets.only(top: 8),
                    // titlePadding: const EdgeInsets.only(top: 8),
                    contentPadding: EdgeInsets.zero,
                    actionsPadding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    icon: Row(
                      children: [
                        const SizedBox(width: 20),
                        widget.timeZoneSearchIcon ?? const Icon(Icons.search_rounded),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            style: widget.timeZoneSearchHintStyle,
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: widget.timeZoneSearchHint ?? 'Search for time zone',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                    content: TimeZoneSelectWidget(
                      searchController: searchController,
                      initTimeZoneData: widget.initTimeZoneData,
                      customTimeZoneDataList: widget.customTimeZoneDataList,
                      onTimeZoneSelected: (TimeZoneData timeZoneData) {
                        widget.onTimeZoneTypeSelected?.call(TimeZoneType.timeZoneTime, timeZoneData);
                        Navigator.of(context).pop();
                        //连续弹出两次到时间选择页面
                        Navigator.of(context).pop();
                      },
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      //   TextButton(
                      //     child: Text('确定'),
                      //     onPressed: () {
                      //       Navigator.of(context).pop();
                      //       print('Selected option: $selectedOption');
                      //     },
                      //   ),
                    ],
                  );
                },
              );
            },
            trailing: const Icon(Icons.keyboard_arrow_right_rounded),
          ),
        ],
      ),
    );
  }
}
