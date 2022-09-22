import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../models/goods.dart';
import '../../../models/goods_group.dart';
import '../../../models/goods_item.dart';
import '../../../models/household.dart';
import '../../../services/goods_item_service.dart';
import '../../../services/goods_service.dart';
import '../../exceptions/error_handler.dart';
import '../../routes/main_routes.dart';

class NewGoodsItemPage extends StatefulWidget {
  final GoodsItemService _goodsItemService;
  final GoodsService _goodsService;
  final Household _household;

  const NewGoodsItemPage(Household household, GoodsItemService goodsItemService,
      GoodsService goodsService,
      {Key? key})
      : _household = household,
        _goodsItemService = goodsItemService,
        _goodsService = goodsService,
        super(key: key);

  @override
  _NewGoodsItemPageState createState() => _NewGoodsItemPageState();
}

class _NewGoodsItemPageState extends State<NewGoodsItemPage> {
  final _formKey = GlobalKey<FormState>();
  Goods? _selectedGoods;

  var _sufficiency = GoodsSufficiency.enough;

  late final Future<void> _initServiceFuture = widget._goodsService.init();

  late final List<Goods> _goodsList = widget._goodsService.getAll();

  List<DropdownMenuItem<Goods>> get _goodsItems => _goodsList
      .map((goods) => DropdownMenuItem(child: Text(goods.name), value: goods))
      .toList();

  List<DropdownMenuItem<GoodsSufficiency>> get _goodsSufficiencyItems =>
      GoodsSufficiency.values
          .map((sufficiency) => DropdownMenuItem(
              child: Text(describeEnum(sufficiency)), value: sufficiency))
          .toList();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vytvor novou nakupni polozku'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Zpet',
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_rounded),
            tooltip: 'Prehled zbozi',
            onPressed: () =>
                Navigator.pushNamed(context, StaticPages.goods.routeName),
          ),
        ],
      ),
      body: _createBodyWidget(context),
    );
  }

  Widget _createBodyWidget(BuildContext context) {
    return FutureBuilder<void>(
        future: _initServiceFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('Inicializace sluzby se nezdarila. Chyba: ' +
                  ErrorHandler.getErrorMessage(snapshot.error));
            }

            //not to use if (snapshot.hasData) future builder is Void type , never returns data!!
            return _createFormWidget(context);
          }
          //default
          return Text(
              'Service was not initialized... Future builder State: ${snapshot.connectionState}');
        });
  }

  Widget _createFormWidget(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget._household.name),
          DropdownButtonFormField<Goods>(
              decoration: const InputDecoration(labelText: 'Vyber zbozi'),
              validator: (value) => value == null ? "Vyberte zbozi" : null,
              value: _selectedGoods,
              onChanged: (Goods? newValue) {
                setState(() {
                  _selectedGoods = newValue!;
                });
              },
              items: _goodsItems),
          DropdownButtonFormField<GoodsSufficiency>(
              value: _sufficiency,
              onChanged: (GoodsSufficiency? newValue) {
                setState(() {
                  _sufficiency = newValue!;
                });
              },
              items: _goodsSufficiencyItems),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await widget._goodsItemService.addNewGoodsItem(GoodsItem(
                      _selectedGoods!, widget._household, _sufficiency));
                  Navigator.pop(context);
                }
              },
              child: const Text('Uloz'),
            ),
          ),
        ],
      ),
    );
  }
}
