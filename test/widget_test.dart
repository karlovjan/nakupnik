// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nakupnik/globals.dart';
import 'package:nakupnik/main.dart';
import 'package:nakupnik/ui/pages/home_page.dart';

import 'hive_test_utils.dart';

void main() {
  setUp(
    () async {
      await settingService.init();
    },
  );

  tearDown(
    () async {
      // await settingService.dispose(); nesmim zavirat box, protoze se pak nesmaze z disku
      await tearDownTestHive();
    },
  );

  testWidgets('Start app test', (WidgetTester tester) async {
    // await setUpTestHive();
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byIcon(Icons.build), findsOneWidget);
    expect(find.byIcon(Icons.build), findsOneWidget);
    expect(find.text('hoj'), findsOneWidget);

    // await tearDownTestHive();
  });
}
