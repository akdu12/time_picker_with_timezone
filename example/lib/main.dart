import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:time_picker_with_timezone/time_picker_with_timezone.dart';

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
              initialTime: TimeOfDay.now(),
              initTimezoneType: 1,
              initTimezone: "Asia/Shanghai",
              initOffsetInHours: 0,
              timezoneHelpPressed: () {
                print('timezoneHelpPressed');
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
