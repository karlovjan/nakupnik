import 'package:hive_flutter/hive_flutter.dart';

import '../models/goods.dart';

class GoodsRepository {
  static const boxName = 'goods';
  static const nameKey = 'name';

  late final Box<String> _box;

  var _initialized = false;

  int get itemsCount => _box.length;

  Future<void> openBox() async {
    if (!_initialized) {
      _initialized = true;
      await initBox(); //it is checked if it is opened and always returns the box value
    }

    if (!_box.isOpen) {
      throw Exception('Box is not opened');
    }
  }

  Future<void> initBox() async {
    _box = await Hive.openBox<String>(boxName);
  }

  Future<void> closeBox() async {
    await _box.close();
  }

  Future<int> putNew(Goods newGoods) {
    return _box.add(newGoods.toJson());
  }

  List<Goods> getAll() {
    return _box.values.map((e) => Goods.fromJson(e)).toList(growable: false);
  }

  Future<void> remove(Goods goods) {
    return _box.delete(_box
        .toMap()
        .entries
        .firstWhere((element) => Goods.fromJson(element.value) == goods)
        .key);
  }
}
