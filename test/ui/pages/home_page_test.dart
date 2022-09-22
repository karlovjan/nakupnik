// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nakupnik/repositories/household_repository.dart';
import 'package:nakupnik/services/household_service.dart';
import 'package:nakupnik/ui/pages/home_page.dart';
import 'package:nakupnik/ui/routes/main_routes.dart';
import 'package:nakupnik/ui/widgets/data_loader_indicator.dart';

import '../../hive_test_utils.dart';

void main() {
  HouseholdService? householdService;

  setUpAll(() async => await Hive.initFlutter());

  setUp(
    () async {
      householdService = HouseholdServiceImpl(HouseholdRepository());
      //TODO odstranit, jen kdyz udelm init tady tak to funguje v init Widget je pozde v testu
      await householdService?.init();
    },
  );

  tearDown(
    () async {
      await householdService!.dispose();
      await Hive.close();
    },
  );

  tearDownAll(
    () async {
      await tearDownTestHive(HouseholdRepository.boxName);
    },
  );

  testWidgets('no household - initial state', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: HomePage(householdService!),
    ));

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byKey(const Key('addHouseholdFAB')), findsOneWidget);
    // expect(find.byKey(const Key('createShoppingCartFAB')), findsOneWidget);
    expect(find.byType(HouseholdListLoaderIndicator), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('You don\'t have any goods. Add some.'), findsOneWidget);
  });

  testWidgets('Settings button exists', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: HomePage(householdService!),
      routes: {
        StaticPages.settings.routeName: (context) => const Text('Fake widget'),
      },
    ));

    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.build), findsOneWidget);
  });
/*
  testWidgets('add household ', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: HomePage(householdService!),
    ));

    await tester.tap(find.byKey(const Key('addHouseholdFAB')));

    await tester.pumpAndSettle(const Duration(seconds: 1));

    // expect(find.byKey(const Key('createShoppingCartFAB')), findsOneWidget);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(TextButton), findsNWidgets(2));

    String householdName = 'Test household name';
    await tester.enterText(find.byType(TextField), householdName);

    await tester.tap(find.byType(TextButton).last);

    await tester.pump(const Duration(seconds: 10));
    await tester.pumpAndSettle(const Duration(seconds: 10));

    expect(find.byType(AlertDialog), findsNothing);
    // expect(find.byType(ListTile), findsOneWidget);
    expect(find.text(householdName), findsOneWidget);
  });
*/

  testWidgets('add household - cancel dialog', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: HomePage(householdService!),
    ));

    await tester.tap(find.byKey(const Key('addHouseholdFAB')));

    await tester.pumpAndSettle(const Duration(seconds: 1));

    // expect(find.byKey(const Key('createShoppingCartFAB')), findsOneWidget);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(TextButton), findsNWidgets(2));

    String householdName = 'Test household name';
    await tester.enterText(find.byType(TextField), householdName);

    await tester.tap(find.byType(TextButton).first);

    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text(householdName), findsNothing);
    expect(find.text('You don\'t have any goods. Add some.'), findsOneWidget);
  });
}
