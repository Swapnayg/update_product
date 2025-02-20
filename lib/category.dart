//import 'package:flutter/cupertino.dart';

class Category_P {
  String iconUrl;
  String name;
  bool featured;
  Category_P({
    required this.name,
    required this.iconUrl,
    required this.featured,
  });

  factory Category_P.fromJson(Map<String, dynamic> json) {
    return Category_P(
      featured: json['featured'],
      iconUrl: json['icon_url'],
      name: json['name'],
    );
  }
}
