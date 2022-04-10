// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nakupnik/repositories/settings_repository.dart';
import 'package:nakupnik/services/settings_service.dart';
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
      // zavre vsechny otevrene boxy
      await Hive.close();
    },
  );

  tearDownAll(
    () async {
      //smaze box z disku
      await tearDownTestHive(SettingsRepository.boxName);
    },
  );

  testWidgets('Start settings test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: SettingsPage(
      settingService: settingService!,
    )));

    final switchWdt =
        tester.widget<Switch>(find.byKey(const Key('darkModeSwitchKey')));
    expect(switchWdt.value, false);
  });

  testWidgets('change dark mode switcher test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: SettingsPage(
      settingService: settingService!,
    )));

    await tester.tap(find.byKey(const Key('darkModeSwitchKey')));
    await tester.pumpAndSettle();
    final switchWdt =
        tester.widget<Switch>(find.byKey(const Key('darkModeSwitchKey')));
    expect(switchWdt.value, true);
  });
}
