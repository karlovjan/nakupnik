import 'package:flutter/material.dart';

import '../../../models/goods.dart';
import '../../../models/goods_group.dart';
import '../../../services/goods_group_service.dart';
import '../../../services/goods_service.dart';
import 'new_goods_group_page.dart';

class NewGoodsPage extends StatefulWidget {
  final GoodsService _goodsService;
  final GoodsGroupService _goodsGroupService;

  const NewGoodsPage(
      GoodsService goodsService, GoodsGroupService goodsGroupService,
      {Key? key})
      : _goodsService = goodsService,
        _goodsGroupService = goodsGroupService,
        super(key: key);

  @override
  _NewGoodsPageState createState() => _NewGoodsPageState();
}

class _NewGoodsPageState extends State<NewGoodsPage> {
  final _formKey = GlobalKey<FormState>();
  final _enterGoodsNameController = TextEditingController();

  GoodsGroup? _selectedGoodsGroup;

  late final List<GoodsGroup> _goodsGroupList =
      widget._goodsGroupService.getAll();

  List<DropdownMenuItem<GoodsGroup>> get _goodsGroupItems => _goodsGroupList
      .map((group) => DropdownMenuItem(child: Text(group.name), value: group))
      .toList();

  @override
  void dispose() {
    _enterGoodsNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vytvor zbozi'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Zpet',
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: _createBodyWidget(context),
    );
  }

  Widget _createBodyWidget(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Zadej nazev zbozi',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nazev zbozi nesmi byt prazdny';
              }

              if (widget._goodsService.existsGoods(value)) {
                return 'Zadane zbozi uz existuje';
              }
              return null;
            },
            controller: _enterGoodsNameController,
          ),
          Row(
            children: [
              Expanded(
                child: ValueListenableBuilder<void>(
                  valueListenable: widget._goodsGroupService.countListenable(),
                  builder: (context, nothing, _) =>
                      DropdownButtonFormField<GoodsGroup>(
                          decoration:
                              const InputDecoration(labelText: 'Vyber zbozi'),
                          validator: (value) =>
                              value == null ? "Vyber domacnost" : null,
                          value: _selectedGoodsGroup,
                          onChanged: (GoodsGroup? newValue) {
                            setState(() {
                              _selectedGoodsGroup = newValue!;
                            });
                          },
                          items: _goodsGroupItems),
                ),
                flex: 2,
              ),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              NewGoodsGroupPage(widget._goodsGroupService))),
                  icon: const Icon(Icons.add),
                  label: const Text('Pridej skupinu'),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await widget._goodsService.addNewGoods(Goods(
                      _enterGoodsNameController.value.text,
                      _selectedGoodsGroup!));
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
