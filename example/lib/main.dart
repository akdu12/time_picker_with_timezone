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
        // Locale('en', 'US'),
        Locale('zh', 'CN'),
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
              // enableTimeZone: true,
              // timeZoneShowType: TimeZoneShowType.abbreviation,
              initialTime: TimeOfDay.now(),
              // initTimeZoneType: TimeZoneType.fixedTime,
              // initTimeZoneData: const TimeZoneData(
              //   name: "Asia/Shanghai",
              //   abbreviation: "CST",
              //   offset: 8,
              //   isDst: false,
              // ),
              // customTimeZoneDataList: [
              //   TimeZoneData(
              //     name: "Asia/Shanghai",
              //     abbreviation: "CST",
              //     offset: 8,
              //     isDst: false,
              //   ),
              //   TimeZoneData(
              //     name: "Asia/Shanghai2",
              //     abbreviation: "CST",
              //     offset: 8,
              //     isDst: false,
              //   ),
              //   TimeZoneData(
              //     name: "Asia/Shanghai3",
              //     abbreviation: "CST",
              //     offset: 8,
              //     isDst: false,
              //   )
              // ],
              timeZoneHelpPressed: () {
                print('timeZoneHelpPressed');
              },
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
