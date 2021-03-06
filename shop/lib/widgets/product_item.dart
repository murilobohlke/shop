import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.PRODUCT_FORM, arguments: product);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                showDialog(
                  context: context, 
                  builder: (ctx) => AlertDialog(
                    title: Text('Excluir produto!'),
                    content: Text('Você deseja realmente excluir o produto?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        }, 
                        child: Text('Não')
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          try{
                            await Provider.of<Products>(context, listen: false).deleteProduct(product.id);
                          } catch(error) {
                            print(error.toString());
                            scaffold.showSnackBar(
                                SnackBar(
                                  content: Text(error.toString()),
                                ),
                              );
                          }
                        }, 
                        child: Text('Sim')
                      ),
                    ],
                  )
                );
               
              },
            )
          ],
        ),
      ),
    );
  }
}
