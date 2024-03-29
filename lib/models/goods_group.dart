import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
class GoodsGroup {
  final String name;

  const GoodsGroup(this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoodsGroup &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return 'GoodsGroup{name: $name}';
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory GoodsGroup.fromMap(Map<String, dynamic> map) {
    return GoodsGroup(
      map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GoodsGroup.fromJson(String source) =>
      GoodsGroup.fromMap(json.decode(source));
}
