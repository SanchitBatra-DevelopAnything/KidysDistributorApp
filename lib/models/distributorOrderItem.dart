import 'package:flutter/material.dart';

class DistributorOrderItem {
  final String item;
  final num quantity;
  final num price;
  final String imageUrl;
  final String CategoryName;

  DistributorOrderItem(
      {required this.item,
      required this.imageUrl,
      required this.CategoryName,
      required this.quantity,
      required this.price});

  Map toJson() => {
        'item': this.item,
        'imageUrl': this.imageUrl,
        'CategoryName': this.CategoryName,
        'quantity': this.quantity,
        'price': this.price,
      };
}
