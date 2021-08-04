import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavorite;

  const ProductGrid(this.showFavorite);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    final List<Product> loadedProducts = showFavorite ? productsProvider.favoriteItems :productsProvider.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: loadedProducts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: loadedProducts[i], child: ProductItem()),
    );
  }
}
