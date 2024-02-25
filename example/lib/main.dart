import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:time_picker_with_timezone/time_picker_with_timezone.dart';
import 'package:time_picker_with_timezone/time_with_timezone.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ExampleWidget(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: [
        Locale('en', 'US'),
        // Locale('zh', 'CN'),
      ], // Scaffold
    ); // MaterialApp
  }
}

class ExampleWidget extends StatelessWidget {
  const ExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showCustomTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              // enableTimeZone: true,
              // timeZoneShowType: TimeZoneShowType.nameAndOffset,
              // initTimeZoneType: TimeZoneType.fixedTime,
              // initTimeZoneData: const TimeZoneData(name: "Asia/Shanghai", abbreviation: "CST", offset: 8, isDst: false),
              // customTimeZoneDataList: const [
              //   TimeZoneData(name: "Asia/Shanghai", abbreviation: "CST", offset: 8, isDst: false),
              //   TimeZoneData(name: "Africa/Algiers", abbreviation: "CET", offset: 1, isDst: false),
              //   TimeZoneData(name: "America/Adak", abbreviation: "HST", offset: -10, isDst: false),
              // ],
              // timeZoneHelpIcon: const Icon(Icons.help),
              // timeZoneHelpPressed: () {
              //   print('timeZoneHelpPressed');
              // },
              // timeZoneTypeTitle: "时区设置",
              // fixedTimeTitle: "固定时间",
              // fixedTimeSubTitle: "时间不随时区变化",
              // timeZoneTimeTitle: "时区时间",
              // timeZoneSearchIcon: const Icon(Icons.search_rounded),
              // timeZoneSearchHint: "搜索时区",
              // timeZoneSearchHintStyle: const TextStyle(fontSize: 16),
            ).then((value) {
              print(value);
            });
          },
          child: const Text("Test"),
        ),
      ), // Center
    );
  }
}
