import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/providers/product.dart';

class Products with ChangeNotifier {
  var _baseUrl ='https://murilob-shop-default-rtdb.firebaseio.com/products';

  List<Product> _items = [];

  List<Product> get items => [..._items];

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadProducts () async {

    final response = await http.get(Uri.parse('$_baseUrl.json'));

    if(response.body != 'null' ){
      Map<String, dynamic> data = jsonDecode(response.body);
      _items.clear();
    data.forEach((productId, productData) { 
      _items.add(
        Product(
          description:productData['description'], 
          id: productId, 
          imageUrl: productData['imageUrl'], 
          price: productData['price'], 
          title: productData['title'],
          isFavorite: productData['isFavorite']),
      );
    });
    notifyListeners();
    }

    return Future.value();
  }

  Future<void> addProduct(Product product) async {
    
    final response = await http
        .post(Uri.parse('$_baseUrl.json'),
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'price': product.price,
              'imageUrl': product.imageUrl,
              'isFavorite': product.isFavorite,
            }));
      _items.add(Product(
          description: product.description,
          id: jsonDecode(response.body)['name'],
          imageUrl: product.imageUrl,
          price: product.price,
          title: product.title));

      notifyListeners();
        
  }

  Future<void> updateProduct(Product product) async {
    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('$_baseUrl/${product.id}.json'),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }));
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async{
    final index = _items.indexWhere((prod) => prod.id == id);

    if(index>=0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();
      
      final response = await http.delete(Uri.parse('$_baseUrl/${product.id}.json'));
              

      if(response.statusCode >400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException('Ocorreu um erro ao excluir o produto');
      } 
    }
  }
}
