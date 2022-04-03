import 'package:nakupnik/models/goods_group.dart';

class Goods {
  final String name;
  final GoodsGroup group;

  Goods(this.name, this.group);
}

class CountedGoods extends Goods {
  final int count;

  CountedGoods(String name, GoodsGroup group, this.count) : super(name, group);
}

class WeightedGoods extends Goods {
  final int weight;
  final String unit;

  WeightedGoods(String name, GoodsGroup group, this.weight, this.unit)
      : super(name, group);
}
