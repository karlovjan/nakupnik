import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
class Household {
  final String name;

  const Household(this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Household &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return 'Household{name: $name}';
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory Household.fromMap(Map<String, dynamic> map) {
    return Household(
      map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Household.fromJson(String source) =>
      Household.fromMap(json.decode(source));
}
