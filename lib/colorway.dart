import 'package:flutter/cupertino.dart';

class Colorway {
  String name;
  Color color;
  bool selected;

  Colorway({required this.name, required this.color, required this.selected});

  factory Colorway.fromJson(Map<String, dynamic> json) {
    return Colorway(
        name: json['name'], color: json['color'], selected: json['selected']);
  }
}
