import 'package:flutter/material.dart';
import 'package:nakupnik/ui/pages/household/new_household_page.dart';

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
  late final Future<void> _initHouseholdServiceFuture =
      widget._householdService.init();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // _disposeHouseholdService();
    super.dispose();
  }

  Future<void> _disposeHouseholdService() async =>
      await widget._householdService.dispose();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seznam domacnosti'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_rounded),
            tooltip: 'Prehled zbozi',
            onPressed: () =>
                Navigator.pushNamed(context, StaticPages.goods.routeName),
          ),
          IconButton(
            icon: const Icon(Icons.build),
            tooltip: 'Nastaveni',
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
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    NewHouseholdPage(widget._householdService))),
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
            'Data was not loaded... Future builder State: ${snapshot.connectionState}');
      },
    );
  }

  Widget _householdListView(BuildContext context) {
    List<Household> households = widget._householdService.getHouseholds();
    if (households.isEmpty) {
      return const Text('You don\'t have any household. Add some.');
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
          trailing: TextButton.icon(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Zrust domacnost'),
                content: Text('Opravdu chcete zrusit domacnost ${household.name}'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ne'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await widget._householdService.delete(household);
                      Navigator.pop(context);
                    },
                    child: const Text('Ano'),
                  ),
                ],
              ),
            ),
            icon: const Icon(Icons.highlight_remove_outlined),
            label: const Text(''),
          ),
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
