import 'package:flutter/foundation.dart';

import '../models/goods.dart';
import '../repositories/goods_repository.dart';

abstract class GoodsService {
  Future<void> init();

  Future<void> dispose();

  Future<int> addNewGoods(Goods newGoods);

  List<Goods> getAll();

  ValueListenable<int> countListenable();

  bool existsGoods(String goodsName);

  Future<void> delete(Goods item);
}

class GoodsServiceImpl extends GoodsService {
  final GoodsRepository _repo;

  late ValueNotifier<int> _countListenable;

  GoodsServiceImpl(this._repo);

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
  Future<int> addNewGoods(Goods newGoods) async {
    int index = await _repo.putNew(newGoods);

    _countListenable.value = _repo.itemsCount;

    return index;
  }

  @override
  ValueListenable<int> countListenable() => _countListenable;

  @override
  List<Goods> getAll() {
    return _repo.getAll();
  }

  @override
  bool existsGoods(String goodsName) {
    return getAll().any((goods) => goods.name == goodsName);
  }

  @override
  Future<void> delete(Goods item) async {
    final result = await _repo.remove(item);
    _countListenable.value = _repo.itemsCount;

    return result;
  }
}
