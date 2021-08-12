import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({Key? key}) : super(key: key);

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    _imageURLFocusNode.addListener(updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final product = ModalRoute.of(context)!.settings.arguments as Product;
        _formData['id'] = product.id;
        _formData['title'] = product.title;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  void updateImageUrl() {
    setState(() {});
  }

  void _saveForm() {
    var isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    final newProduct = Product(
      description: _formData['description'].toString(),
      id: _formData['id'].toString(),
      imageUrl: _formData['imageUrl'].toString(),
      price: double.parse(_formData['price'].toString()),
      title: _formData['title'].toString(),
    );

    if (ModalRoute.of(context)!.settings.arguments != null) {
      Provider.of<Products>(context, listen: false).updateProduct(newProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(newProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURLFocusNode.removeListener(updateImageUrl);
    _imageURLFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário Produto'),
        actions: [
          IconButton(
              onPressed: () {
                _saveForm();
              },
              icon: Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _formData['title'] != null
                    ? _formData['title'].toString()
                    : '',
                decoration: InputDecoration(labelText: 'Título'),
                textInputAction: TextInputAction.next,
                onSaved: (value) => _formData['title'] = value!,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Informe um título válido!';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['price'] != null
                    ? _formData['price'].toString()
                    : '',
                decoration: InputDecoration(labelText: 'Preço'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onSaved: (value) => _formData['price'] = double.parse(value!),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
              ),
              TextFormField(
                initialValue: _formData['description'] != null
                    ? _formData['description'].toString()
                    : '',
                decoration: InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
                onSaved: (value) => _formData['description'] = value!,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _imageUrlController,
                      decoration: InputDecoration(
                        labelText: 'URL da Imagem',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      focusNode: _imageURLFocusNode,
                      onSaved: (value) => _formData['imageUrl'] = value!,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, left: 10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty
                        ? Text('Informa a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
