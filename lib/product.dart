import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:update_product/colorway.dart';
import 'package:update_product/size.dart';
import 'package:update_product/Review.dart';

class Product {
  List<String> image;
  String? id;
  String? name;
  int? price;
  int? quantity;
  double? rating;
  String? description;
  String? p_category;
  String? p_brand;
  List<Colorway> colors;
  List<Size_P> sizes;
  List<Review_p> reviews;
  String? storeName;

  Product({
    required this.image,
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.rating,
    required this.description,
    required this.p_category,
    required this.p_brand,
    required this.colors,
    required this.sizes,
    required this.reviews,
    required this.storeName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    try {
      return Product(
        image: json['image'],
        name: json['name'],
        id: json['id'],
        price: json['price'],
        quantity: json['quantity'],
        rating: json['rating'],
        p_category: json['p_category'],
        p_brand: json['p_brand'],
        description: json['description'],
        colors: (json['colors'] as List)
            .map((data) => Colorway.fromJson(data))
            .toList(),
        sizes: (json['sizes'] as List)
            .map((data) => Size_P.fromJson(data))
            .toList(),
        reviews: (json['reviews'] as List)
            .map((data) => Review_p.fromJson(data))
            .toList(),
        storeName: json['store_name'],
      );
    } catch (e) {
      debugPrint(e.toString());
      return Product(
        image: [],
        id: "0",
        name: "",
        price: 0,
        quantity: 0,
        rating: 0,
        p_category: "",
        p_brand: "",
        description: "",
        colors: [],
        sizes: [],
        reviews: [],
        storeName: "",
      );
    }
  }
}
