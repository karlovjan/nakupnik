import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'repositories/household_repository.dart';
import 'repositories/settings_repository.dart';
import 'services/household_service.dart';
import 'services/settings_service.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/household_page.dart';
import 'ui/pages/settings_page.dart';
import 'ui/routes/main_routes.dart';

void main() async {
  await Hive.initFlutter();
  final SettingService _settingsService =
      SettingServiceImpl(SettingsRepository());
  await _settingsService.init();
  runApp(MyApp(
    settingService: _settingsService,
  ));
}

class MyApp extends StatelessWidget {
  final SettingService _settingsService;

  const MyApp({Key? key, required SettingService settingService})
      : _settingsService = settingService,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _settingsService.darkModeChangedListenable(),
      builder: (context, darkModeValue, _) {
        return MaterialApp(
          themeMode: darkModeValue ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData.dark(),
          routes: {
            StaticPages.home.routeName: (context) =>
                HomePage(HouseholdServiceImpl(HouseholdRepository())),
            StaticPages.settings.routeName: (context) =>
                SettingsPage(settingService: _settingsService),
            StaticPages.household.routeName: (context) => const HouseholdPage(),
          },
        );
      },
    );
  }
}
