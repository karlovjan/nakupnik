import 'package:flutter/material.dart';

import 'repositories/hive_repository.dart';
import 'services/settings_service.dart';

final SettingService _settingService = SettingServiceImpl(HiveRepository());

void main() async {
  await _settingService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _settingService.darkModeChangedListenable(),
      builder: (context, darkModeValue, child) {
        return MaterialApp(
          themeMode: darkModeValue ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData.dark(),
          home: Scaffold(
            body: Center(
              child: Switch(
                value: darkModeValue,
                onChanged: (val) {
                  _settingService.changeDarkMode(val);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
