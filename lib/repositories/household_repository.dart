import 'package:hive_flutter/hive_flutter.dart';

import '../models/household.dart';

class HouseholdRepository {
  static const boxName = 'household';

  late final Box<String> _box;

  int get itemsCount => _box.length;

  Future<void> openBox() async {
    _box = await Hive.openBox<String>(
        boxName); //it is checked if it is opened and always returns the box value
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
}
