import 'package:flutter/material.dart';

import '../../globals.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _darkMode;

  @override
  void initState() {
    super.initState();

    _darkMode = settingService.isDarkMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Dark theme'),
                const SizedBox(
                  width: 8,
                ),
                Switch(
                  value: _darkMode,
                  onChanged: (newValue) {
                    settingService.changeDarkMode(newValue);
                    setState(() {
                      _darkMode = newValue;
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
