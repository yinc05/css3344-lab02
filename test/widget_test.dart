import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:first_flutter_app/main.dart';

Future<void> portrait(WidgetTester tester) async {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  await tester.pumpWidget(const StudentInfoApp());
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Portrait and landscape retain role and remain scrollable', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await portrait(tester);
    expect(find.text('PEIGI CHAI PEI YIN'), findsOneWidget);
    expect(find.text('Student ID: BCS24090055'), findsOneWidget);
    expect(find.byKey(const ValueKey('portrait-layout')), findsOneWidget);
    final dropdown = find.byKey(const ValueKey('material-role'));
    await tester.scrollUntilVisible(
      dropdown,
      250,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();
    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Developer').last);
    await tester.pumpAndSettle();
    expect(find.text('Selected role: Developer'), findsOneWidget);
    tester.view.physicalSize = const Size(852, 393);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('landscape-layout')), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('cupertino-role')),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('cupertino-role')));
    await tester.pumpAndSettle();
    final wheel = tester.widget<CupertinoPicker>(find.byType(CupertinoPicker));
    expect(wheel.scrollController!.initialItem, 1);
    await tester.drag(find.byType(CupertinoPicker), const Offset(0, -40));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Selected role: Designer'), findsOneWidget);
    tester.view.physicalSize = const Size(393, 852);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('material-role')),
      250,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();
    expect(tester.widget<DropdownButton<String>>(dropdown).value, 'Designer');
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Material date updates Cupertino initial value; cancel preserves date',
    (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await portrait(tester);
      final materialDate = find.byKey(const ValueKey('material-date'));
      await tester.scrollUntilVisible(
        materialDate,
        250,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();
      await tester.tap(materialDate);
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);
      expect(tester.takeException(), isNull, reason: 'Material open');
      final today = DateUtils.dateOnly(DateTime.now());
      // Select another day in this month, including on the first day.
      final day = today.day == 1 ? 1 : today.day - 1;
      await tester.tap(find.text('$day').last);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      final selected = DateTime(today.year, today.month, day);
      await tester.tap(find.byKey(const ValueKey('cupertino-date')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'Cupertino open');
      expect(
        tester
            .widget<CupertinoDatePicker>(find.byType(CupertinoDatePicker))
            .initialDateTime,
        selected,
      );
      final previousLabel = tester
          .widget<Text>(find.byKey(const ValueKey('selected-date')))
          .data;
      await tester.drag(find.byType(CupertinoDatePicker), const Offset(0, 40));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.byKey(const ValueKey('selected-date'))).data,
        previousLabel,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
