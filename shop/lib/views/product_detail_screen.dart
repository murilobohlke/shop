import 'package:flutter/material.dart';
import 'package:shop/providers/product.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen();

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(product.imageUrl),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'R\$ ${product.price}',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey
              ),
            ),
             SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
