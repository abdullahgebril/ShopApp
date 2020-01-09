import 'package:flutter/material.dart';

import '../Provider/Product.dart';
import 'package:provider/provider.dart';
import '../Provider/Products.dart';

class EditProductScreen extends StatefulWidget {
  final String id;
  EditProductScreen(this.id);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _decriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrLFocusNode = FocusNode();
  final _keyForm = GlobalKey<FormState>();
  var _isinit = true;
  var _isLoading = false;
  var initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  var _editProduct = Product(
    id: null,
    title: '',
    description: '',
    imageUrl: '',
    price: 0.0,
  );

  @override
  void initState() {
    _imageUrLFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isinit) {
      if (!widget.id.isEmpty) {
        _editProduct =
            Provider.of<Products>(context, listen: false).findById(widget.id);
        initValues = {
          'title': _editProduct.title,
          'description': _editProduct.description,
          'price': _editProduct.price.toString(),
          //'imageUrl':''
        };
        _imageUrlController.text = _editProduct.imageUrl;
      }
    }
    _isinit = false;

    super.didChangeDependencies();
  }

  void dispose() {
    _priceFocusNode.dispose();
    _decriptionFocusNode.dispose();
    _imageUrLFocusNode.dispose();
    _imageUrLFocusNode.removeListener(updateImageUrl);
    super.dispose();
  }

  @override
  void updateImageUrl() {
    if (!_imageUrLFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final _isValid = _keyForm.currentState.validate();
    if (!_isValid) {
      return;
    }
    _keyForm.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editProduct.id != null) {
      await Provider.of<Products>(context)
          .updateProduct(_editProduct.id, _editProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context).addItem(_editProduct);
      }
      catch (error) {
        await showDialog(context: context, builder: (cxt) =>
            AlertDialog(
              title: Text('An error occured'),
              content: Text('Something went wrong'),
              actions: <Widget>[
                FlatButton(child: Text('ok'), onPressed: () {
                  Navigator.of(context).pop();
                },)
              ],
            ));
      }
      finally {
        setState(() {
          _isLoading = true;
        });
        Navigator.of(context).pop();
      }
    }
  }


    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Your Product'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveForm,
            )
          ],
        ),
        body: _isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _keyForm,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  initialValue: initValues['title'],
                  decoration: InputDecoration(
                    labelText: 'title',
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter Valid Title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editProduct = Product(
                        title: value,
                        description: _editProduct.description,
                        imageUrl: _editProduct.imageUrl,
                        price: _editProduct.price,
                        id: _editProduct.id,
                        isFavorite: _editProduct.isFavorite);
                  },
                ),
                TextFormField(
                    initialValue: initValues['price'],
                    decoration: InputDecoration(
                      labelText: 'price',
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_decriptionFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter  Price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please Enter Valid Number';
                      }
                      if (double.parse(value) <= 0) {
                        return 'Please Enter Valid Number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editProduct = Product(
                          title: _editProduct.title,
                          description: _editProduct.description,
                          imageUrl: _editProduct.imageUrl,
                          price: double.parse(value),
                          id: _editProduct.id,
                          isFavorite: _editProduct.isFavorite);
                    }),
                TextFormField(
                    initialValue: initValues['description'],
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    focusNode: _decriptionFocusNode,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter  Description';
                      }
                      if (value.length < 10) {
                        return 'Should be greater Than 10 charchaters.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editProduct = Product(
                          title: _editProduct.title,
                          description: value,
                          imageUrl: _editProduct.imageUrl,
                          price: _editProduct.price,
                          id: _editProduct.id,
                          isFavorite: _editProduct.isFavorite);
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.all(10),
                        child: _imageUrlController.text.isEmpty
                            ? Center(
                          child: Text('Enter URL'),
                        )
                            : FittedBox(
                          child: Image.network(
                            _imageUrlController.text,
                            fit: BoxFit.cover,
                          ),
                        )),
                    Expanded(
                      child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'ImageURL',
                          ),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imageUrLFocusNode,
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter  URl';
                            }
                            if (!value.startsWith('http') &&
                                !value.startsWith('https')) {
                              return ' Please Enter valid URL';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _editProduct = Product(
                                title: _editProduct.title,
                                description: _editProduct.description,
                                imageUrl: value,
                                price: _editProduct.price,
                                id: _editProduct.id,
                                isFavorite: _editProduct.isFavorite);
                          }),
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
