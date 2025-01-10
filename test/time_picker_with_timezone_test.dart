import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // test('adds one to input values', () {
  //   final calculator = Calculator();
  //   expect(calculator.addOne(2), 3);
  //   expect(calculator.addOne(-7), -6);
  //   expect(calculator.addOne(0), 1);
  // });

  testWidgets(
      'Material3 - Padding between apm and time textField - hourDialType == _HourDialType.twelveHour && timeOfDayFormat == TimeOfDayFormat.a_space_h_colon_mm',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(540, 960);
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        restorationScopeId: 'app',
        home: Scaffold(
          body: Builder(builder: (BuildContext context) {
            return Localizations.override(
              context: context,
              locale: const Locale('zh', 'CN'),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 9, minute: 0),
                      orientation: Orientation.portrait,
                    );
                  },
                  child: const Text('Show Time Picker'),
                ),
              ),
            );
          }),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    final Finder text1Finder = find.text('AM');
    final Finder parent1Finder = find.ancestor(
      of: text1Finder,
      matching: find.byType(Center),
    );

    final Finder text2Finder = find.text('9');
    final Finder parent2Finder = find.ancestor(
      of: text2Finder,
      matching: find.byType(Center),
    );

    final Offset parent1TopRight = tester.getTopRight(parent1Finder);
    final Offset parent2TopLeft = tester.getTopLeft(parent2Finder);

    expect(parent2TopLeft.dx - parent1TopRight.dx, 12.0);
  });
}
