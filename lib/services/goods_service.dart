import '../models/goods.dart';
import '../repositories/goods_repository.dart';

abstract class GoodsService {
  Future<void> init();

  Future<void> dispose();

  Future<int> addNewGoods(Goods newGoods);
}

class GoodsServiceImpl extends GoodsService {
  final GoodsRepository _repo;

  GoodsServiceImpl(this._repo);

  @override
  Future<void> dispose() async {
    //TODO use it in statefull widget
    await _repo.closeBox();
  }

  @override
  Future<void> init() async {
    await _repo.openBox();
  }

  @override
  Future<int> addNewGoods(Goods newGoods) {
    return _repo.putNew(newGoods);
  }
}
