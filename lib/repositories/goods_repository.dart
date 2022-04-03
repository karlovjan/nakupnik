import 'package:hive_flutter/hive_flutter.dart';

class GoodsRepository {
  static const boxName = 'goods';
  static const nameKey = 'name';

  late final Box _box;

  var _hiveInitialized = false;

  Future<void> initHive() async {
    await Hive.initFlutter();
    _hiveInitialized = true;
  }

  get isHiveInitialized => _hiveInitialized;

  Future<void> openBox() async {
    _box = await Hive.openBox(
        boxName); //it is checked if it is opened and always returns the box value
  }

  Future<void> closeBox() async {
    await _box.close();
  }
}
