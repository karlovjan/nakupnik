import 'package:hive_flutter/hive_flutter.dart';

import '../models/household.dart';

class HouseholdRepository {
  static const boxName = 'household';

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

  Future<int> putNew(Household newHousehold) {
    return _box.add(newHousehold.toJson());
  }

  List<Household> getAll() {
    return _box.values
        .map((e) => Household.fromJson(e))
        .toList(growable: false);
  }

  Future<void> remove(Household household) {
    return _box.delete(_box
        .toMap()
        .entries
        .firstWhere((element) => Household.fromJson(element.value) == household)
        .key);
  }
}
