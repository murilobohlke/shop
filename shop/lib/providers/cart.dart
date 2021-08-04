import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shop/providers/product.dart';

class CarItem {
  final String title;
  final int quantity;
  final double price;
  final String id;

  CarItem(
      {required this.title,
      required this.id,
      required this.price,
      required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CarItem> _items = {};

  Map<String, CarItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;

    _items.forEach((key, carItem) {
      total += carItem.price * carItem.quantity;
    });

    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(product.id, (oldProduct) {
        return CarItem(
          title: oldProduct.title,
          id: oldProduct.id,
          price: oldProduct.price,
          quantity: oldProduct.quantity + 1,
        );
      });
    } else {
      _items.putIfAbsent(product.id, () {
        return CarItem(
            title: product.title,
            id: Random().nextDouble().toString(),
            price: product.price,
            quantity: 1);
      });
    }

    notifyListeners();
  }
}
