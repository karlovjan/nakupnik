import 'package:flutter/foundation.dart';

import '../models/goods_group.dart';
import '../repositories/goods_group_repository.dart';

abstract class GoodsGroupService {
  Future<void> init();

  Future<void> dispose();

  Future<int> addNewGoodsGroup(GoodsGroup newGoodsGroup);

  List<GoodsGroup> getAll();

  ValueListenable<int> countListenable();

  bool existsGoodsGroup(String goodsGroupName);

  Future<void> delete(GoodsGroup item);
}

class GoodsGroupServiceImpl extends GoodsGroupService {
  final GoodsGroupRepository _repo;

  late ValueNotifier<int> _countListenable;

  GoodsGroupServiceImpl(this._repo);

  @override
  Future<void> init() async {
    await _repo.openBox();
    _countListenable = ValueNotifier(_repo.itemsCount);
  }

  @override
  Future<void> dispose() async {
    //TODO use it in statefull widget
    _countListenable.dispose();
    await _repo.closeBox();
  }

  @override
  Future<int> addNewGoodsGroup(GoodsGroup newGoodsGroup) async {
    int index = await _repo.putNew(newGoodsGroup);

    _countListenable.value = _repo.itemsCount;

    return index;
  }

  @override
  ValueListenable<int> countListenable() => _countListenable;

  @override
  List<GoodsGroup> getAll() {
    return _repo.getAll();
  }

  @override
  bool existsGoodsGroup(String goodsGroupName) {
    return getAll().any((group) => group.name == goodsGroupName);
  }

  @override
  Future<void> delete(GoodsGroup item) async {
    final result = await _repo.remove(item);
    _countListenable.value = _repo.itemsCount;

    return result;
  }
}
