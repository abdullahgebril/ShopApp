import 'package:flutter/material.dart';
import '../Provider/Cart.dart';
import 'package:provider/provider.dart';
import '../widgets/Cartitem.dart';
import '../Provider/orders.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('your Cart'),
        ),
        body: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Chip(
                      label: Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)},',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    FlatButton(
                      child: Text('Place Order'),
                      onPressed:  cart.totalAmount<=0?null :()async {
                       await Provider.of<orders>(context).addOrder(cart.items.values.toList(), cart.totalAmount);
                     cart.clearitem();
                      },

                    ),

                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) => Cartitem(
                    cart.items.values.toList()[index].id,
                    cart.items.keys.toList()[index],
                    cart.items.values.toList()[index].title,
                    cart.items.values.toList()[index].quantity,
                    cart.items.values.toList()[index].price,
                  ),
                  itemCount: cart.items.length,
                ),
              ),
            ],
        ));
  }
}

