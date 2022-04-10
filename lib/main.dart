import 'package:flutter/material.dart';
import 'package:nakupnik/repositories/settings_repository.dart';
import 'package:nakupnik/ui/pages/settings_page.dart';
import 'package:nakupnik/ui/routes/main_routes.dart';

import 'services/settings_service.dart';
import 'ui/pages/home_page.dart';

void main() async {
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
      builder: (context, darkModeValue, child) {
        return MaterialApp(
          themeMode: darkModeValue ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData.dark(),
          initialRoute: StaticPages.home.routeName,
          routes: {
            // When navigating to the "/" route, build the FirstScreen widget.
            StaticPages.home.routeName: (context) => const HomePage(),
            // When navigating to the "/second" route, build the SecondScreen widget.
            StaticPages.settings.routeName: (context) =>
                SettingsPage(settingService: _settingsService),
          },
        );
      },
    );
  }
}
