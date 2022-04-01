import 'package:flutter/material.dart';

import 'globals.dart';
import 'ui/pages/home_page.dart';

void main() async {
  await settingService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: settingService.darkModeChangedListenable(),
      builder: (context, darkModeValue, child) {
        return MaterialApp(
          themeMode: darkModeValue ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData.dark(),
          home: const HomePage(),
        );
      },
    );
  }
}
