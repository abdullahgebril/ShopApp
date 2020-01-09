import 'package:flutter/cupertino.dart';
import 'package:shop_app/Provider/Cart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class orderItem {
  final String id;
  final double amount;
  DateTime dateTime;
  List<CartItem> products;

  orderItem({this.id, this.amount, this.products, this.dateTime});
}

class orders with ChangeNotifier {

  List<orderItem> _items = [];

  List<orderItem> get itms {
    return [..._items];
  }
  var token;
  orders(this.token,this._items);

  Future<void> fetchOrders() async {
    final url = 'https://marketapp-fe785.firebaseio.com/orders.json?auth=$token';
    final response = await http.get(url);
    final orderData = json.decode(response.body) as Map<String, dynamic>;
    if (orderData == null) {
      return;
    }
    final List<orderItem> loadingOrders = [];
    orderData.forEach((orderID, orderData) {
      loadingOrders.add(
        orderItem(
          id: orderID,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['DateTime']),
          products: (orderData['Products'] as List<dynamic>)
              .map((cartitem) => CartItem(
                  id: cartitem['id'],
                  title: cartitem['title'],
                  price: cartitem['price'],
                  quantity: cartitem['quantity']))
              .toList(),
        ),
      );
    });
    _items = loadingOrders;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> itemproduct, double total) async {
    final timestamp = DateTime.now();
    final url = 'https://marketapp-fe785.firebaseio.com/orders.json?auth=$token';
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'DateTime': timestamp.toIso8601String(),
          'Products': itemproduct
              .map((cartitem) => {
                    'id': cartitem.id,
                    'title': cartitem.title,
                    'price': cartitem.price,
                    'quantity': cartitem.quantity,
                  })
              .toList(),
        }));
    _items.insert(
        0,
        orderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: itemproduct,
            dateTime: timestamp));
  }
}
