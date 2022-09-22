import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:nakupnik/models/goods_item.dart';
import 'package:nakupnik/models/household.dart';
import 'package:nakupnik/services/goods_item_service.dart';
import 'package:nakupnik/services/goods_service.dart';
import 'package:nakupnik/ui/pages/goods_item/new_goods_item_page.dart';

import '../../exceptions/error_handler.dart';
import '../../routes/main_routes.dart';
import '../../widgets/data_loader_indicator.dart';

class HouseholdPage extends StatefulWidget {
  final GoodsItemService _goodsItemService;
  final GoodsService _goodsService;

  const HouseholdPage(
      {Key? key,
      required GoodsItemService goodsItemService,
      required GoodsService goodsService})
      : _goodsItemService = goodsItemService,
        _goodsService = goodsService,
        super(key: key);

  @override
  _HouseholdPageState createState() => _HouseholdPageState();
}

class _HouseholdPageState extends State<HouseholdPage> {
  late final Future<void> _initServiceFuture = widget._goodsItemService.init();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final household = ModalRoute.of(context)!.settings.arguments as Household;

    return Scaffold(
      appBar: AppBar(
        title: Text('Domacnosti - ${household.name}'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Back',
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          IconButton(
            icon: const Icon(Icons.build),
            tooltip: 'Nastaveni',
            onPressed: () =>
                Navigator.pushNamed(context, StaticPages.settings.routeName),
          ),
        ],
      ),
      // body is the majority of the screen.
      body: _createBodyWidget(context, household),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            key: const Key('addGoodsFAB'),
            heroTag: 'addGoodsFABTag',
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewGoodsItemPage(household,
                        widget._goodsItemService, widget._goodsService))),
            tooltip: 'Pridej zbozi',
            child: const Icon(Icons.add),
          ),
          const SizedBox(
            width: 8,
          ),
          FloatingActionButton(
            key: const Key('sendEmailFAB'),
            heroTag: 'sendEmailFAB',
            onPressed: () async {
              bool sent = await _sendHouseholdOverviewEmail(household);
              if(!sent) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("E-mail se neodeslal"),
                  ),
                );
              }
            },
            tooltip: 'Posli email',
            child: const Icon(Icons.email_rounded),
          ),
        ],
      ),
    );
  }

  Widget _createBodyWidget(BuildContext context, Household household) {
    return FutureBuilder<void>(
      future: _initServiceFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const GoodsItemListLoaderIndicator();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Nejdou nacist polozky domacnosti. Chyba: ${ErrorHandler.getErrorMessage(snapshot.error)}');
          }

          //not to use if (snapshot.hasData) future builder is Void type , never returns data!!
          return ValueListenableBuilder<void>(
            valueListenable: widget._goodsItemService.countListenable(),
            builder: (context, nothing, _) =>
                _householdListView(context, household),
          );
        }
        //default
        return Text(
            'Data was not loaded... Future builder State: ${snapshot.connectionState}');
      },
    );
  }

  Widget _householdListView(BuildContext context, Household household) {
    List<GoodsItem> items = widget._goodsItemService.getAll(household);
    if (items.isEmpty) {
      return const Text('Nemate zadne zbozi. Pridejte si nejake...');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          key: ValueKey(item),
          leading: _getColoredBox(item.sufficiency),
          title: Text(item.goods.name),
          subtitle: Text(item.goods.group.name),
          trailing: TextButton.icon(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Zrus polozku'),
                content:
                    Text('Opravdu chcete zrusit polozku ${item.goods.name}'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ne'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await widget._goodsItemService.delete(item);
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

  Widget _getColoredBox(GoodsSufficiency sufficiency) {
    if (sufficiency == GoodsSufficiency.lack) {
      return const ColoredBox(
        color: Colors.red,
        child: SizedBox(
          width: 20,
          height: 30,
        ),
      );
    }
    if (sufficiency == GoodsSufficiency.soonNeeded) {
      return const ColoredBox(
        color: Colors.yellow,
        child: SizedBox(
          width: 20,
          height: 30,
        ),
      );
    }
    return const ColoredBox(
      color: Colors.green,
      child: SizedBox(
        width: 20,
        height: 30,
      ),
    );
  }

  Future<bool> _sendHouseholdOverviewEmail(Household household) async {
    bool sent = false;

    List<GoodsItem> items = widget._goodsItemService.getAll(household);
    if (items.isEmpty) {
      return false;
    }

    items.sort((a, b) {
      if(a.sufficiency == b.sufficiency){
        return 0;
      } else if (a.sufficiency == GoodsSufficiency.enough){
        return 1;
      }
      return -1;
    });
    String body = items.map((e) => '<li style="color:${_getGooItemCssColor(e)};">${e.goods.name}</li>').join();
    body = '<h1>${household.name.toUpperCase()}</h1><ul>$body</ul>';

    try {
      final Email mail = Email(
        body: body,
        subject: 'co je potreba koupit v domacnosti ${household.name}',
        isHTML: true,
      );

      await FlutterEmailSender.send(mail);

      sent = true;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      // platformResponse = error.toString();
    }

    return sent;
  }

  String _getGooItemCssColor(GoodsItem e) => (e.sufficiency == GoodsSufficiency.lack ? 'red' : (e.sufficiency == GoodsSufficiency.soonNeeded ? 'yellow' : 'green'));
}
