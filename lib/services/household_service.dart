import 'package:flutter/foundation.dart';

import '../models/household.dart';
import '../repositories/household_repository.dart';

abstract class HouseholdService {
  Future<void> init();

  Future<void> dispose();

  Future<int> addNewHousehold(Household newHousehold);

  List<Household> getHouseholds();

  ValueListenable<int> countListenable();

  bool existsHousehold(String householdName);

  Future<void> delete(Household household);
}

class HouseholdServiceImpl extends HouseholdService {
  final HouseholdRepository _repo;

  late final ValueNotifier<int> _countListenable = ValueNotifier(_repo.itemsCount);

  HouseholdServiceImpl(this._repo);

  @override
  Future<void> init() async {
    await _repo.openBox();
  }

  @override
  Future<void> dispose() async {
    _countListenable.dispose();
    await _repo.closeBox();
  }

  @override
  Future<int> addNewHousehold(Household newHousehold) async {
    int index = await _repo.putNew(newHousehold);

    _countListenable.value = _repo.itemsCount;

    return index;
  }

  @override
  ValueListenable<int> countListenable() => _countListenable;

  @override
  List<Household> getHouseholds() {
    return _repo.getAll();
  }

  @override
  bool existsHousehold(String householdName) {
    return getHouseholds().any((household) => household.name == householdName);
  }

  @override
  Future<void> delete(Household household) async {
    final result = await _repo.remove(household);
    _countListenable.value = _repo.itemsCount;

    return result;
  }
}
