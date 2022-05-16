import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'goods_group.dart';

@immutable
class Goods {
  final String name;
  final GoodsGroup group;

  const Goods(this.name, this.group);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Goods &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          group == other.group;

  @override
  int get hashCode => name.hashCode ^ group.hashCode;

  @override
  String toString() {
    return 'Goods{name: $name, group: $group}';
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'group': group.toJson(),
    };
  }

  factory Goods.fromMap(Map<String, dynamic> map) {
    return Goods(
      map['name'],
      GoodsGroup.fromJson(map['group']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Goods.fromJson(String source) => Goods.fromMap(json.decode(source));
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
