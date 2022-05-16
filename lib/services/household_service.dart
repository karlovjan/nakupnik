import 'package:flutter/foundation.dart';

import '../models/household.dart';
import '../repositories/household_repository.dart';

abstract class HouseholdService {
  Future<void> init();

  Future<void> dispose();

  Future<int> addNewHousehold(Household newHousehold);

  List<Household> getHouseholds();

  ValueListenable<void> countListenable();
}

class HouseholdServiceImpl extends HouseholdService {
  final HouseholdRepository _repo;

  late ValueNotifier<int> _countListenable;

  HouseholdServiceImpl(this._repo);

  @override
  Future<void> init() async {
    await _repo.openBox();
    _countListenable = ValueNotifier(_repo.itemsCount);
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
  ValueListenable<void> countListenable() => _countListenable;

  @override
  List<Household> getHouseholds() {
    return _repo.getAll();
  }
}
