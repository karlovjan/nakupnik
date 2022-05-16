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
      // await householdService?.init();
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
    expect(find.byKey(const Key('addGoodsFAB')), findsOneWidget);
    // expect(find.byKey(const Key('createShoppingCartFAB')), findsOneWidget);
    expect(find.byType(HouseholdListLoaderIndicator), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 100));
    // await tester.pumpAndSettle(const Duration(seconds: 1));
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
}
