import 'package:flutter/cupertino.dart';

class Product with ChangeNotifier {
  final String description;
  final String id;
  final String title;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product(
      {required this.description,
      required this.id,
      required this.imageUrl,
      this.isFavorite = false,
      required this.price,
      required this.title});

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
