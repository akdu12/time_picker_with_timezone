// Copyright 2024 Charles Lee. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:time_picker_with_timezone/timezone_select_widget.dart';
import 'package:time_picker_with_timezone/timezone_util.dart';

class TimezoneTypeSelectWidget extends StatefulWidget {
  const TimezoneTypeSelectWidget({
    super.key,
    this.initTimezoneType,
    this.initTimezone,
    this.initOffsetInHours,
    this.fixedTimeTitle,
    this.fixedTimeSubTitle,
    this.timezoneTimeTitle,
    // this.timezoneTimeSubTitle,

    this.timezoneSearchIcon,
    this.timezoneSearchHintStyle,
    this.timezoneSearchHint,
    this.onTimezoneTypeSelected,
  });

  final int? initTimezoneType;
  final String? initTimezone;
  final int? initOffsetInHours;

  final String? fixedTimeTitle;
  final String? fixedTimeSubTitle;
  final String? timezoneTimeTitle;

  // final String? timezoneTimeSubTitle;

  final Icon? timezoneSearchIcon;
  final String? timezoneSearchHint;
  final TextStyle? timezoneSearchHintStyle;

  final Function(int type, String? timezone, int? offsetInHours)? onTimezoneTypeSelected;

  @override
  State<TimezoneTypeSelectWidget> createState() => _TimezoneTypeSelectWidgetState();
}

class _TimezoneTypeSelectWidgetState extends State<TimezoneTypeSelectWidget> {
  final visualDensity = const VisualDensity(horizontal: -4, vertical: 0);
  final contentPadding = const EdgeInsets.symmetric(horizontal: 14);
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
          RadioListTile<int>(
            title: Text(widget.fixedTimeTitle ?? '固定时间'),
            subtitle: Text(
              widget.fixedTimeSubTitle ?? '时间不随时区变化',
              style: titleTextStyle,
            ),
            value: 0,
            groupValue: widget.initTimezoneType,
            visualDensity: visualDensity,
            contentPadding: contentPadding,
            onChanged: (int? value) {
              widget.onTimezoneTypeSelected?.call(value!, "", 0);
              Navigator.of(context).pop();
            },
          ),
          RadioListTile<int>(
            title: Text(widget.timezoneTimeTitle ?? '时区时间'),
            subtitle: widget.initTimezone != null && widget.initTimezone!.isNotEmpty && widget.initOffsetInHours != null
                ? Text(
                    "${widget.initTimezone}, UTC${TimezoneUtil.timeOffset2String(widget.initOffsetInHours)}",
                    style: titleTextStyle,
                  )
                : null,
            value: 1,
            groupValue: widget.initTimezoneType,
            visualDensity: visualDensity,
            contentPadding: contentPadding,
            secondary: const Icon(Icons.keyboard_arrow_right_rounded),
            onChanged: (int? value) {
              showDialog(
                context: context,
                barrierColor: Colors.transparent, //多个barrier叠加后背景太深，不好看
                builder: (BuildContext context) {
                  return AlertDialog(
                    insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                    titlePadding: const EdgeInsets.only(top: 4),
                    contentPadding: EdgeInsets.zero,
                    actionsPadding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    title: Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 18),
                            widget.timezoneSearchIcon ?? const Icon(Icons.search_rounded),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                style: widget.timezoneSearchHintStyle,
                                controller: searchController,
                                decoration: InputDecoration(
                                  hintText: widget.timezoneSearchHint ?? '搜索时区',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                        const Divider(height: 1),
                      ],
                    ),
                    content: TimezoneSelectWidget(
                      searchController: searchController,
                      initTimezone: widget.initTimezone,
                      initOffsetInHours: widget.initOffsetInHours,
                      onTimezoneSelected: (String timezone, int offsetInHours) {
                        widget.onTimezoneTypeSelected?.call(value!, timezone, offsetInHours);
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
          ),
        ],
      ),
    );
  }
}
