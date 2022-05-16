import 'package:flutter/material.dart';

import '../../models/household.dart';
import '../../services/household_service.dart';
import '../exceptions/error_handler.dart';
import '../routes/main_routes.dart';
import '../widgets/data_loader_indicator.dart';

class HomePage extends StatefulWidget {
  final HouseholdService _householdService;

  const HomePage(HouseholdService householdService, {Key? key})
      : _householdService = householdService,
        super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<void> _initHouseholdServiceFuture = widget._householdService.init();

  late TextEditingController _enterHouseholdNameController;

  @override
  void initState() {
    super.initState();

    _enterHouseholdNameController = TextEditingController();
  }
  
  @override
  void dispose() {
    _disposeHouseholdService();
    _enterHouseholdNameController.dispose();
    super.dispose();
  }

  Future<void> _disposeHouseholdService() async => await widget._householdService.dispose();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Household list'),
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
        key: const Key('addHouseholdFAB'),
        heroTag: 'addHouseholdFAB',
        onPressed: () => showDialog<void>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Pridej novou domacnost'),
            content: TextField(
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Zadej nazev domacnosti'),
              controller: _enterHouseholdNameController,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Zavri'),
              ),
              TextButton(
                onPressed: () {
                  widget._householdService.addNewHousehold(Household(_enterHouseholdNameController.value.text));
                  Navigator.pop(context);
                },
                child: const Text('Uloz'),
              ),
            ],
          ),
        ),
        tooltip: 'Pridej domacnost',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _createBodyWidget(BuildContext context) {
    return FutureBuilder<void>(
      future: _initHouseholdServiceFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const HouseholdListLoaderIndicator();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('cannot get list of households. Error: ' +
                ErrorHandler.getErrorMessage(snapshot.error));
          }

          //not to use if (snapshot.hasData) future builder is Void type , never returns data!!

          return ValueListenableBuilder<void>(
            valueListenable: widget._householdService.countListenable(),
            builder: (context, nothing, _) => _householdListView(context),
          );
        }
        //default
        return Text(
            'Sync preferences was not loaded... Future builder State: ${snapshot.connectionState}');
      },
    );
  }

  Widget _householdListView(BuildContext context) {
    List<Household> households = widget._householdService.getHouseholds();
    if (households.isEmpty) {
      return const Text('You don\'t have any goods. Add some.');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: households.length,
      itemBuilder: (context, index) {
        final household = households[index];
        return ListTile(
          key: ValueKey(household),
          title: Text(household.name),
          onTap: () => Navigator.pushNamed(
              context, StaticPages.household.routeName,
              arguments: household),
        );
      },
    );
  }

/*
  floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            key: const Key('addGoodsFAB'),
            heroTag: 'addGoodsFABTag',
            onPressed: () {
              //open dialog
              widget._goodsService.addNewGoods();
            },
            tooltip: 'Pridej zbozi',
            child: const Icon(Icons.add),
          ),
          const SizedBox(
            width: 8,
          ),
          FloatingActionButton(
            key: const Key('createShoppingCartFAB'),
            heroTag: 'createShoppingCartFABTag',
            onPressed: () {
              //
            },
            tooltip: 'Nakupni listek',
            child: const Icon(Icons.add_shopping_cart),
          ),
        ],
      ),
   */
}
