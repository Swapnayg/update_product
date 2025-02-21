import 'package:flutter/cupertino.dart';

class Colorway {
  String name;
  Color color;
  String color_code;
  bool selected;

  Colorway(
      {required this.name,
      required this.color,
      required this.color_code,
      required this.selected});

  factory Colorway.fromJson(Map<String, dynamic> json) {
    return Colorway(
        name: json['name'],
        color: json['color'],
        color_code: json['color_code'],
        selected: json['selected']);
  }
}
