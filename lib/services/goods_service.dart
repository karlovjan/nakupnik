import 'package:nakupnik/repositories/goods_repository.dart';

abstract class GoodsService {
  Future<void> init();

  Future<void> dispose();
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
    if (!_repo.isHiveInitialized) {
      await _repo.initHive();
    }

    await _repo.openBox();
  }
}
