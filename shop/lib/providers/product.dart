import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

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

  Future<void> toggleFavorite() async {
    isFavorite = !isFavorite;
    notifyListeners();

    try{
      final url ='https://murilob-shop-default-rtdb.firebaseio.com/products/$id.json';

      final response = await http.patch(
        Uri.parse(url),
        body: json.encode({
          'isFavorite': isFavorite,
        })
      );

      if(response.statusCode>=400){
        isFavorite = !isFavorite;
        notifyListeners();
      }
    } catch(error) {
      isFavorite = !isFavorite;
      notifyListeners();
    }
  }
}
