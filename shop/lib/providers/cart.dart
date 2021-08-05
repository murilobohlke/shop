import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shop/providers/product.dart';

class CartItem {
  final String title;
  final int quantity;
  final double price;
  final String id;
  final String productId;

  CartItem(
      {required this.title,
      required this.id,
      required this.price,
      required this.productId,
      required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
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
        return CartItem(
          productId: product.id,
          title: oldProduct.title,
          id: oldProduct.id,
          price: oldProduct.price,
          quantity: oldProduct.quantity + 1,
        );
      });
    } else {
      _items.putIfAbsent(product.id, () {
        return CartItem(
            productId: product.id,
            title: product.title,
            id: Random().nextDouble().toString(),
            price: product.price,
            quantity: 1);
      });
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);

    notifyListeners();
  }

  void clear() {
    _items = {};

    notifyListeners();
  }
}
