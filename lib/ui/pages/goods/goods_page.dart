import 'package:flutter/material.dart';

import '../../../models/goods.dart';
import '../../../services/goods_group_service.dart';
import '../../../services/goods_service.dart';
import '../../exceptions/error_handler.dart';
import '../../routes/main_routes.dart';
import '../../widgets/data_loader_indicator.dart';
import 'new_goods_page.dart';

class GoodsPage extends StatefulWidget {
  final GoodsService _goodsService;
  final GoodsGroupService _goodsGroupService;

  const GoodsPage(
      GoodsService goodsService, GoodsGroupService goodsGroupService,
      {Key? key})
      : _goodsService = goodsService,
        _goodsGroupService = goodsGroupService,
        super(key: key);

  @override
  State<GoodsPage> createState() => _GoodsPageState();
}

class _GoodsPageState extends State<GoodsPage> {
  late final Future<void> _initServiceFuture = _initService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // _disposeService();
    super.dispose();
  }
  
  Future<void> _initService() async {
    await widget._goodsService.init();
    await widget._goodsGroupService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prehled zbozi'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Back',
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          IconButton(
            icon: const Icon(Icons.groups_rounded),
            tooltip: 'Prehled skupin zbozi',
            onPressed: () =>
                Navigator.pushNamed(context, StaticPages.goodsGroups.routeName),
          ),
        ],
      ),
      // body is the majority of the screen.
      body: _createBodyWidget(context),
      floatingActionButton: FloatingActionButton(
        key: const Key('addGoodsFAB'),
        heroTag: 'addGoodsFAB',
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewGoodsPage(
                    widget._goodsService, widget._goodsGroupService))),
        tooltip: 'Pridej zbozi',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _createBodyWidget(BuildContext context) {
    return FutureBuilder<void>(
      future: _initServiceFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const GoodsListLoaderIndicator();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('cannot get list of goods. Error: ' +
                ErrorHandler.getErrorMessage(snapshot.error));
          }

          //not to use if (snapshot.hasData) future builder is Void type , never returns data!!
          return ValueListenableBuilder<void>(
            valueListenable: widget._goodsService.countListenable(),
            builder: (context, nothing, _) => _createGoodsListView(context),
          );
        }
        //default
        return Text(
            'Data was not loaded... Future builder State: ${snapshot.connectionState}');
      },
    );
  }

  Widget _createGoodsListView(BuildContext context) {
    List<Goods> goodsList = widget._goodsService.getAll();
    if (goodsList.isEmpty) {
      return const Text('Nemate zadne zbozi. Pridejte nove.');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: goodsList.length,
      itemBuilder: (context, index) {
        final goods = goodsList[index];
        return ListTile(
          key: ValueKey(goods),
          title: Text(goods.name),
          trailing: TextButton.icon(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Zrus polozku'),
                content:
                Text('Opravdu chcete zrusit polozku ${goods.name}'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ne'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await widget._goodsService.delete(goods);
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
}
