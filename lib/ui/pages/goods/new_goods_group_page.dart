import 'package:flutter/material.dart';
import 'package:nakupnik/models/goods_group.dart';
import 'package:nakupnik/services/goods_group_service.dart';

class NewGoodsGroupPage extends StatefulWidget {
  final GoodsGroupService _goodsGroupService;

  const NewGoodsGroupPage(GoodsGroupService goodsGroupService, {Key? key})
      : _goodsGroupService = goodsGroupService,
        super(key: key);

  @override
  _NewGoodsGroupPageState createState() => _NewGoodsGroupPageState();
}

class _NewGoodsGroupPageState extends State<NewGoodsGroupPage> {
  final _formKey = GlobalKey<FormState>();
  final _enterGoodsGroupNameController = TextEditingController();

  @override
  void dispose() {
    _enterGoodsGroupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vytvor skupinu zbozi'),
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
              hintText: 'Zadej nazev skupiny',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nazev skupiny zbozi nesmi byt prazdny';
              }

              if (widget._goodsGroupService.existsGoodsGroup(value)) {
                return 'Zadana skupina zbozi uz existuje';
              }
              return null;
            },
            controller: _enterGoodsGroupNameController,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await widget._goodsGroupService.addNewGoodsGroup(
                      GoodsGroup(_enterGoodsGroupNameController.value.text));
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
