import 'package:hive_flutter/hive_flutter.dart';

import '../models/goods_group.dart';

class GoodsGroupRepository {
  static const boxName = 'goods_group';
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

  Future<int> putNew(GoodsGroup newGoodsGroup) {
    return _box.add(newGoodsGroup.toJson());
  }

  List<GoodsGroup> getAll() {
    return _box.values
        .map((e) => GoodsGroup.fromJson(e))
        .toList(growable: false);
  }

  Future<void> remove(GoodsGroup item) {
    return _box.delete(_box
        .toMap()
        .entries
        .firstWhere((element) => GoodsGroup.fromJson(element.value) == item)
        .key);
  }
}
