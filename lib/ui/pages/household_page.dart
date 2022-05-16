import 'package:flutter/material.dart';
import 'package:nakupnik/models/household.dart';

import '../routes/main_routes.dart';

class HouseholdPage extends StatefulWidget {
  const HouseholdPage({Key? key}) : super(key: key);

  @override
  _HouseholdPageState createState() => _HouseholdPageState();
}

class _HouseholdPageState extends State<HouseholdPage> {
  @override
  Widget build(BuildContext context) {
    final household = ModalRoute.of(context)!.settings.arguments as Household;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Household goods'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Back',
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          IconButton(
            icon: const Icon(Icons.build),
            tooltip: 'Settings',
            onPressed: () =>
                Navigator.pushNamed(context, StaticPages.settings.routeName),
          ),
        ],
      ),
      // body is the majority of the screen.
      body: _createBodyWidget(context),
      floatingActionButton: FloatingActionButton(
        key: const Key('addGoodsFAB'),
        heroTag: 'addGoodsFABTag',
        onPressed: () {
          //open dialog
        },
        tooltip: 'Pridej zbozi',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _createBodyWidget(BuildContext context) {
    return const Text('TODO');
  }
}
