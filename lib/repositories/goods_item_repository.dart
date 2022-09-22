import 'package:hive_flutter/hive_flutter.dart';

import '../models/goods_item.dart';
import '../models/household.dart';

class GoodsItemRepository {
  static const boxName = 'goods_items';

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

  Future<int> putNew(GoodsItem newGoods) {
    return _box.add(newGoods.toJson());
  }

  List<GoodsItem> getAll(Household household) {
    return _box.values
        .map((e) => GoodsItem.fromJson(e))
        .where((gi) => gi.household == household)
        .toList(growable: false);
  }

  Future<void> remove(GoodsItem item) {
    return _box.delete(_box
        .toMap()
        .entries
        .firstWhere((element) => GoodsItem.fromJson(element.value) == item)
        .key);
  }
}
