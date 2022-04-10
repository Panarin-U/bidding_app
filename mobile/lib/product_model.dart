// To parse this JSON data, do
//
//     final product = productFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class Product {
  Product({
    required this.id,
    required this.name,
    required this.biddingPrice,
    required this.endTime,
  });

  final int id;
  final String name;
  final int biddingPrice;
  final int endTime;

  Product copyWith({
    required int id,
    required String name,
    required int biddingPrice,
    required int endTime,
  }) =>
      Product(
        id: id,
        name: name,
        biddingPrice: biddingPrice,
        endTime: endTime,
      );

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    biddingPrice: json["biddingPrice"] == null ? null : json["biddingPrice"],
    endTime: json["endTime"] == null ? null : json["endTime"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "biddingPrice": biddingPrice == null ? null : biddingPrice,
    "endTime": endTime == null ? null : endTime,
  };
}
