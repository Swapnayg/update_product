//import 'package:flutter/cupertino.dart';

class Review_p {
  String photoUrl;
  String name;
  String review;
  double rating;

  Review_p(
      {required this.photoUrl,
      required this.name,
      required this.review,
      required this.rating});

  factory Review_p.fromJson(Map<String, dynamic> json) {
    return Review_p(
        photoUrl: json['photo_url'],
        name: json['name'],
        review: json['review'],
        rating: json['rating']);
  }
}
