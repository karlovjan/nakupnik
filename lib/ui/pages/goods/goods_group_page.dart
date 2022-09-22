import 'package:flutter/material.dart';

import '../../../models/goods_group.dart';
import '../../../services/goods_group_service.dart';
import '../../exceptions/error_handler.dart';
import '../../widgets/data_loader_indicator.dart';
import 'new_goods_group_page.dart';

class GoodsGroupPage extends StatefulWidget {
  final GoodsGroupService _goodsGroupService;

  const GoodsGroupPage(GoodsGroupService goodsGroupService, {Key? key})
      : _goodsGroupService = goodsGroupService,
        super(key: key);

  @override
  State<GoodsGroupPage> createState() => _GoodsGroupPageState();
}

class _GoodsGroupPageState extends State<GoodsGroupPage> {
  late final Future<void> _initGoodsGroupServiceFuture =
      widget._goodsGroupService.init();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // _disposeService();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prehled skupin zbozi'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Back',
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      // body is the majority of the screen.
      body: _createBodyWidget(context),
      floatingActionButton: FloatingActionButton(
        key: const Key('addGoodsGroupFAB'),
        heroTag: 'addGoodsGroupFAB',
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    NewGoodsGroupPage(widget._goodsGroupService))),
        tooltip: 'Pridej skupinu zbozi',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _createBodyWidget(BuildContext context) {
    return FutureBuilder<void>(
      future: _initGoodsGroupServiceFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const GoodsListLoaderIndicator();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('cannot get list of goods groups. Error: ' +
                ErrorHandler.getErrorMessage(snapshot.error));
          }

          //not to use if (snapshot.hasData) future builder is Void type , never returns data!!
          return ValueListenableBuilder<void>(
            valueListenable: widget._goodsGroupService.countListenable(),
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
    List<GoodsGroup> goodsGroupList = widget._goodsGroupService.getAll();
    if (goodsGroupList.isEmpty) {
      return const Text('Nemate zadnou skupinu zbozi. Pridejte novou.');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: goodsGroupList.length,
      itemBuilder: (context, index) {
        final goods = goodsGroupList[index];
        return ListTile(
          key: ValueKey(goods),
          title: Text(goods.name),
          trailing: TextButton.icon(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Zrus polozku'),
                content: Text('Opravdu chcete zrusit polozku ${goods.name}'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ne'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await widget._goodsGroupService.delete(goods);
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
