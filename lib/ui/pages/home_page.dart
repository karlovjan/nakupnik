import 'package:flutter/material.dart';

import '../routes/main_routes.dart';

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
            tooltip: 'Settings',
            onPressed: () =>
                Navigator.pushNamed(context, StaticPages.settings.routeName),
          ),
        ],
      ),
      // body is the majority of the screen.
      body: const Text("hoj"),
      // floatingActionButton: Row(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: <Widget>[
      //     FloatingActionButton(
      //       key: const Key('addGoodsFAB'),
      //       onPressed: () {
      //         //
      //       },
      //       tooltip: 'Pridej zbozi',
      //       child: const Icon(Icons.add),
      //     ),
      //     const SizedBox(
      //       width: 8,
      //     ),
      //     FloatingActionButton(
      //       key: const Key('createShoppingCartFAB'),
      //       onPressed: () {
      //         //
      //       },
      //       tooltip: 'Nakupni listek',
      //       child: const Icon(Icons.add_shopping_cart),
      //     ),
      //   ],
      // ),
    );
  }
}
