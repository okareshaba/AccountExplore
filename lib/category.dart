import 'package:flutter/material.dart';

class Category {
  final String name;

  final int id;

  const Category({
    @required this.name,
    @required this.id

  })  : assert(name != null);


  @override
  String toString() {
    return name;
  }
}