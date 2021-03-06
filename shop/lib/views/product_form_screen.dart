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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageURLFocusNode.addListener(updateImageUrl);
  }

  @override
  void didChangeDependencies() {
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

  Future<void> _saveForm() async{
    var isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    setState(() {
      isLoading = true;
    });

    final newProduct = Product(
      description: _formData['description'].toString(),
      id: _formData['id'].toString(),
      imageUrl: _formData['imageUrl'].toString(),
      price: double.parse(_formData['price'].toString()),
      title: _formData['title'].toString(),
    );

      try{
        if (ModalRoute.of(context)!.settings.arguments != null) {
          await Provider.of<Products>(context, listen: false).updateProduct(newProduct);
        } else {
          await Provider.of<Products>(context, listen: false).addProduct(newProduct);
        }
        Navigator.of(context).pop();
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Ocorreu um erro!'),
                  content: Text('Erro inesperado ao salvar o produto'),
                  actions: [
                    TextButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      } finally {
        setState(() {
          isLoading = false;
        });
      }
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
        title: Text('Formul??rio Produto'),
        actions: [
          IconButton(
              onPressed: () {
                _saveForm();
              },
              icon: Icon(Icons.save))
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formData['title'] != null
                          ? _formData['title'].toString()
                          : '',
                      decoration: InputDecoration(labelText: 'T??tulo'),
                      textInputAction: TextInputAction.next,
                      onSaved: (value) => _formData['title'] = value!,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Informe um t??tulo v??lido!';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['price'] != null
                          ? _formData['price'].toString()
                          : '',
                      decoration: InputDecoration(labelText: 'Pre??o'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onSaved: (value) =>
                          _formData['price'] = double.parse(value!),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['description'] != null
                          ? _formData['description'].toString()
                          : '',
                      decoration: InputDecoration(labelText: 'Descri????o'),
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
                              : Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
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
