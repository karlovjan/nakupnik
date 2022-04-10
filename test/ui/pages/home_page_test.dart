// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nakupnik/main.dart';
import 'package:nakupnik/repositories/settings_repository.dart';
import 'package:nakupnik/services/settings_service.dart';
import 'package:nakupnik/ui/pages/home_page.dart';
import 'package:nakupnik/ui/pages/settings_page.dart';

import '../../hive_test_utils.dart';

void main() {
  SettingService? settingService;
  setUp(
    () async {
      settingService = SettingServiceImpl(SettingsRepository());
      await settingService!.init();
    },
  );

  tearDown(
    () async {
      // await settingService!.dispose();
      await Hive.close();
    },
  );

  tearDownAll(
    () async {
      await tearDownTestHive(SettingsRepository.boxName);
    },
  );

  testWidgets('Start app test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(
      settingService: settingService!,
    ));

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byIcon(Icons.build), findsOneWidget);
    expect(find.text('hoj'), findsOneWidget);
  });

  testWidgets('Settings button exists', (WidgetTester tester) async {
    // await setUpTestHive();
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      settingService: settingService!,
    ));

    await tester.tap(find.byIcon(Icons.build));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPage), findsOneWidget);
  });
}
