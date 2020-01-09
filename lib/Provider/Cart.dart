import 'package:flutter/cupertino.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;
  CartItem({this.id, this.title, this.price, this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }
  double get totalAmount{
    double total = 0.0;
     _items.forEach((key,CartItem){
      total += CartItem.price* CartItem.quantity;
    });
    return total;
  }
  void removeItem(String productId) {
     _items.remove(productId);
     notifyListeners();
  }
  void additem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          price: existingItem.price,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  void removeSingleItem(String productid) {
    if(!_items.containsKey(productid)) {
      return;
    }
    if(_items[productid].quantity>1) {
      _items.update(productid, (existingproduct)=>CartItem(id: existingproduct.id,title: existingproduct.title,
      price: existingproduct.price,quantity: existingproduct.quantity -1
      ));
    }
    else {
      _items.remove(productid);
    }
  }
  void clearitem(){
    _items = {};
    notifyListeners();
  }
}
