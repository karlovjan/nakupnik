import 'package:flutter/material.dart';

import '../../services/settings_service.dart';

class SettingsPage extends StatefulWidget {
  final SettingService _settingsService;

  const SettingsPage({Key? key, required SettingService settingService})
      : _settingsService = settingService,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsPageState();

  bool isDarkMode() => _settingsService.isDarkMode();
}

class _SettingsPageState extends State<SettingsPage> {
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
                  key: const Key('darkModeSwitchKey'),
                  value: widget.isDarkMode(),
                  onChanged: (newValue) {
                    widget._settingsService.changeDarkMode(newValue);
                    setState(() {
                      //just rebuild
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
