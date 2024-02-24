// Copyright 2024 Charles Lee. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:time_picker_with_timezone/timezone_select_widget.dart';
import 'package:time_picker_with_timezone/timezone_util.dart';

class TimeZoneTypeSelectWidget extends StatefulWidget {
  const TimeZoneTypeSelectWidget({
    super.key,
    this.initTimeZoneType,
    this.initTimeZone,
    this.initOffsetInHours,
    this.fixedTimeTitle,
    this.fixedTimeSubTitle,
    this.timeZoneTimeTitle,
    // this.timezoneTimeSubTitle,

    this.timeZoneSearchIcon,
    this.timeZoneSearchHintStyle,
    this.timeZoneSearchHint,
    this.onTimeZoneTypeSelected,
  });

  final int? initTimeZoneType;
  final String? initTimeZone;
  final int? initOffsetInHours;

  final String? fixedTimeTitle;
  final String? fixedTimeSubTitle;
  final String? timeZoneTimeTitle;

  // final String? timezoneTimeSubTitle;

  final Icon? timeZoneSearchIcon;
  final String? timeZoneSearchHint;
  final TextStyle? timeZoneSearchHintStyle;

  final Function(int type, String? timezone, int? offsetInHours)? onTimeZoneTypeSelected;

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
            title: Text(widget.fixedTimeTitle ?? '固定时间'),
            subtitle: Text(
              widget.fixedTimeSubTitle ?? '时间不随时区变化',
              style: titleTextStyle,
            ),
            selected: widget.initTimeZoneType == 0,
            visualDensity: visualDensity,
            contentPadding: contentPadding,
            leading: Visibility.maintain(
              visible: widget.initTimeZoneType == 0,
              child: const Icon(Icons.done_rounded),
            ),
            onTap: () {
              widget.onTimeZoneTypeSelected?.call(0, "", 0);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text(widget.timeZoneTimeTitle ?? '时区时间'),
            subtitle: widget.initTimeZone != null && widget.initTimeZone!.isNotEmpty && widget.initOffsetInHours != null
                ? Text(
                    "${widget.initTimeZone}, UTC${TimezoneUtil.timeOffset2String(widget.initOffsetInHours)}",
                    style: titleTextStyle,
                  )
                : null,
            selected: widget.initTimeZoneType == 1,
            visualDensity: visualDensity,
            contentPadding: contentPadding,
            leading: Visibility.maintain(
              visible: widget.initTimeZoneType == 1,
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
                              hintText: widget.timeZoneSearchHint ?? '搜索时区',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                    content: TimeZoneSelectWidget(
                      searchController: searchController,
                      initTimeZone: widget.initTimeZone,
                      initOffsetInHours: widget.initOffsetInHours,
                      onTimeZoneSelected: (String timeZone, int offsetInHours) {
                        widget.onTimeZoneTypeSelected?.call(1, timeZone, offsetInHours);
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
