import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/providers/cart.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order(
      {required this.id,
      required this.total,
      required this.date,
      required this.products});
}

class Orders with ChangeNotifier {
  List<Order> _items = [];
  var _baseUrl ='https://murilob-shop-default-rtdb.firebaseio.com/orders';

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final response = await http.post(
      Uri.parse('$_baseUrl.json'),
      body: json.encode({
            'total': cart.totalAmount,
            'date': date.toIso8601String(),
            'products': cart.items.values.map((cartItem) => {
              'id': cartItem.id,
              'price': cartItem.price,
              'productId': cartItem.productId,
              'title': cartItem.title,
              'quantity':cartItem.quantity
            }).toList(),
        })
      
    );
    _items.insert(
        0,
        Order(
            id: jsonDecode(response.body)['name'],
            total: cart.totalAmount,
            date: date,
            products: cart.items.values.toList()));

    notifyListeners();
  }
}
