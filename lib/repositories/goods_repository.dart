import 'package:hive_flutter/hive_flutter.dart';
import 'package:nakupnik/models/goods.dart';

class GoodsRepository {
  static const boxName = 'goods';
  static const nameKey = 'name';

  late final Box _box;

  int get itemsCount => _box.length;

  Future<void> openBox() async {
    _box = await Hive.openBox(
        boxName); //it is checked if it is opened and always returns the box value
  }

  Future<void> closeBox() async {
    await _box.close();
  }

  Future<int> putNew(Goods newGoods) {
    return _box.add(newGoods.toJson());
  }
}
