import 'package:flutter/cupertino.dart';

class Brand_p {
  String name;
  String logourl;
  String password;

  Brand_p({required this.name, required this.logourl, required this.password});

  factory Brand_p.fromJson(Map<String, dynamic> json) {
    return Brand_p(
        name: json['name'],
        logourl: json['logourl'],
        password: json['password']);
  }
}
