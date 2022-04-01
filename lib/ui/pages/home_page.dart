import 'package:flutter/material.dart';

import 'settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.build),
            tooltip: 'Preferences',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            ),
          ),
        ],
      ),
      // body is the majority of the screen.
      body: const Text("hoj"),
    );
  }
}
