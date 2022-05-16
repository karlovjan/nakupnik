import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'goods.dart';
import 'household.dart';

enum GoodsSufficiency { enough, lack, soonNeeded }

class GoodsItem {
  final Goods goods;
  final Household household;
  final GoodsSufficiency sufficiency;

  GoodsItem(this.goods, this.household,
      [this.sufficiency = GoodsSufficiency.enough]);

  @override
  String toString() {
    return 'GoodsItem{goods: $goods, household: $household, sufficiency: $sufficiency}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoodsItem &&
          runtimeType == other.runtimeType &&
          goods == other.goods &&
          household == other.household &&
          sufficiency == other.sufficiency;

  @override
  int get hashCode =>
      goods.hashCode ^ household.hashCode ^ sufficiency.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'goods': goods.toJson(),
      'household': household.toJson(),
      'sufficiency': describeEnum(sufficiency),
    };
  }

  factory GoodsItem.fromMap(Map<String, dynamic> map) {
    return GoodsItem(
      Goods.fromJson(map['goods']),
      Household.fromJson(map['household']),
      GoodsSufficiency.values.firstWhere(
        (e) => e.toString() == 'GoodsSufficiency.' + map['sufficiency'],
        orElse: () => GoodsSufficiency.enough,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory GoodsItem.fromJson(String source) =>
      GoodsItem.fromMap(json.decode(source));
}
