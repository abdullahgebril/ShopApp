import 'package:flutter/cupertino.dart';
import 'package:shop_app/Provider/Product.dart';
import 'Product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
//    Product(
//      id: 'p1',
//      title: 'Red Shirt',
//      description: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imageUrl:
//          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl:
//          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
  ];
  var token;
  Products(this.token,this._items);
  var showFavorite = false;
  List<Product> get items {
    if (showFavorite == true) {
      return _items.where((prodct) => prodct.isFavorite).toList();
    } else {
      return [..._items];
    }
  }

  void showfavoriteOnly() {
    showFavorite = true;
    notifyListeners();
  }

  void showAll() {
    showFavorite = false;
    notifyListeners();
  }

  Future<void> addItem(Product product) async {
    final url = 'https://marketapp-fe785.firebaseio.com/products.json?auth=$token';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          }));
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
  Future<void> FetchProducts()async {
    final url = 'https://marketapp-fe785.firebaseio.com/products.json?auth=$token';
    try {
      final response = await http.get(url);
      final productsData = json.decode(response.body) as Map<String,dynamic>;
      final List<Product> loadingList = [];
      productsData.forEach((productID,productData ){

        loadingList.add(Product(
          id: productID,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
            isFavorite:productData['isFavorite'],
        ));
      });
      _items = loadingList;
      notifyListeners();
    } catch(error) {
      throw error;
    }
  }



  Future<void> updateProduct(String id, Product product)async {

    final productindex = _items.indexWhere((pro) => pro.id == id);
    if (productindex >= 0) {
      final url = 'https://marketapp-fe785.firebaseio.com/products/$id.json?auth=$token';
     await http.patch(url,body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
      }));
      _items[productindex] = product;
      notifyListeners();
    } else {
      print('No Product');
    }

  }

  Future<void> deleteproduct(String id) async {
    final url = 'https://marketapp-fe785.firebaseio.com/products/$id.json?auth=$token';
    await http.delete(url);
    _items.removeWhere((pro) => pro.id == id);

    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((pro) => pro.id == id);
  }
}
