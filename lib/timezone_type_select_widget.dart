import 'package:flutter/material.dart';
import 'package:time_picker_with_timezone/timezone_select_widget.dart';

class TimezoneTypeSelectWidget extends StatefulWidget {
  const TimezoneTypeSelectWidget({super.key, required this.initType, required this.initTimezone});

  final int initType;
  final String initTimezone;

  @override
  State<TimezoneTypeSelectWidget> createState() => _TimezoneTypeSelectWidgetState();
}

class _TimezoneTypeSelectWidgetState extends State<TimezoneTypeSelectWidget> {
  final visualDensity = const VisualDensity(horizontal: -4, vertical: 0);

  final searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    // print('TimezoneTypeSelectWidget build');
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          RadioListTile<int>(
            title: Text('固定时间'),
            subtitle: Text(
              '时间不随时区变化',
              style: TextStyle(fontSize: 12),
            ),
            value: 0,
            groupValue: 0,
            visualDensity: visualDensity,
            contentPadding: EdgeInsets.zero,
            selected: true,
            onChanged: (int? value) {
              setState(() {
                // _selectedOption = value!;
              });
            },
          ),
          RadioListTile<int>(
            title: Text('时区时间'),
            subtitle: Text(
              'Asia/Shanghai,UTC+8',
              style: TextStyle(fontSize: 12),
            ),
            value: 1,
            groupValue: 0,
            visualDensity: visualDensity,
            contentPadding: EdgeInsets.zero,
            secondary: Icon(Icons.keyboard_arrow_right_rounded),
            onChanged: (int? value) {
              // setState(() {
              //   _selectedOption = value!;
              // });

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
                            const Icon(Icons.search_rounded),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                decoration: const InputDecoration(
                                  hintText: '搜索时区',
                                  border: InputBorder.none,
                                ),
                                // onChanged: (s){
                                //   print(s);
                                // },
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
                      initTimezone: '',
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('取消'),
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
