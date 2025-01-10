// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';
import 'package:time_picker_with_timezone/time_picker_with_timezone.dart';

void main() {
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(const MyApp());
  //
  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);
  //
  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();
  //
  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });

  // testWidgets('Material3 - Padding between apm and time textField - hourDialType == _HourDialType.twelveHour && timeOfDayFormat == TimeOfDayFormat.a_space_h_colon_mm',
  //     (WidgetTester tester) async {
  //
  //   tester.view.physicalSize = const Size(540, 960);
  //   tester.view.devicePixelRatio = 1;
  //
  //   await tester.pumpWidget(
  //     MaterialApp(
  //       localizationsDelegates: const [
  //         GlobalMaterialLocalizations.delegate,
  //         GlobalWidgetsLocalizations.delegate,
  //         GlobalCupertinoLocalizations.delegate,
  //       ],
  //       supportedLocales: const [
  //         Locale('zh', 'CN'),
  //       ],
  //       theme: ThemeData(useMaterial3: true),
  //       restorationScopeId: 'app',
  //
  //       home: Scaffold(
  //         body: Builder(builder: (BuildContext context) {
  //           return Center(
  //             child: ElevatedButton(
  //               onPressed: () {
  //                 // 显示时间选择器
  //                 showTimeWithTimeZonePicker(
  //                   context: context,
  //                   initialTime: const TimeOfDay(hour: 9, minute: 0),
  //                   orientation: Orientation.portrait,
  //                 );
  //               },
  //               child: const Text('Show Time Picker'),
  //             ),
  //           );
  //         }),
  //       ),
  //     ),
  //   );
  //
  //   await tester.tap(find.byType(ElevatedButton));
  //   await tester.pumpAndSettle();
  //
  //   final Finder text1Finder = find.text('上午');
  //   final Finder parent1Finder = find.ancestor(
  //     of: text1Finder,
  //     matching: find.byType(Center),
  //   );
  //
  //   final Finder text2Finder = find.text('9');
  //   final Finder parent2Finder = find.ancestor(
  //     of: text2Finder,
  //     matching: find.byType(Center),
  //   );
  //
  //   final Offset parent1TopRight = tester.getTopRight(parent1Finder);
  //   final Offset parent2TopLeft = tester.getTopLeft(parent2Finder);
  //   print("parent1Finder: ${tester.getTopLeft(parent1Finder)} ${tester.getBottomRight(parent1Finder)}");
  //   print("parent2Finder: ${tester.getTopLeft(parent2Finder)} ${tester.getBottomRight(parent2Finder)}");
  //
  //   expect(parent2TopLeft.dx - parent1TopRight.dx, 12.0);
  //
  // });
}
