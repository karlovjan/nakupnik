import 'package:flutter/foundation.dart';

import '../models/goods_item.dart';
import '../models/household.dart';
import '../repositories/goods_item_repository.dart';

abstract class GoodsItemService {
  Future<void> init();

  Future<void> dispose();

  Future<int> addNewGoodsItem(GoodsItem newGoodsItem);

  List<GoodsItem> getAll(Household household);

  ValueListenable<int> countListenable();

  Future<void> delete(GoodsItem item);
}

class GoodsItemServiceImpl extends GoodsItemService {
  final GoodsItemRepository _repo;

  late ValueNotifier<int> _countListenable;

  GoodsItemServiceImpl(this._repo);

  @override
  Future<void> init() async {
    await _repo.openBox();
    _countListenable = ValueNotifier(_repo.itemsCount);
  }

  @override
  Future<void> dispose() async {
    //TODO use it in a statefull widget
    _countListenable.dispose();
    await _repo.closeBox();
  }

  @override
  Future<int> addNewGoodsItem(GoodsItem newGoodsItem) async {
    int index = await _repo.putNew(newGoodsItem);

    // _countListenable.value = GoodsItemNotifierValue(newGoodsItem.household, _repo.getAll(newGoodsItem.household).length);
    _countListenable.value = _repo.itemsCount;

    return index;
  }

  @override
  ValueListenable<int> countListenable() => _countListenable;

  @override
  List<GoodsItem> getAll(Household household) {
    return _repo.getAll(household);
  }

  @override
  Future<void> delete(GoodsItem item) async {
    final result = await _repo.remove(item);
    _countListenable.value = _repo.itemsCount;

    return result;
  }
}
