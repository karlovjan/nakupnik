import 'package:nakupnik/models/household.dart';

class GoodsItemNotifierValue {
  Household household;
  int goodsItemCount;

  GoodsItemNotifierValue(this.household, this.goodsItemCount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoodsItemNotifierValue &&
          runtimeType == other.runtimeType &&
          household == other.household &&
          goodsItemCount == other.goodsItemCount;

  @override
  int get hashCode => household.hashCode ^ goodsItemCount.hashCode;
}