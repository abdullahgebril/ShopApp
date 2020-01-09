import 'package:flutter/material.dart';
import '../Provider/orders.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final orderItem order;
  OrderItem(this.order);
  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(widget.order.dateTime.toString()),
            trailing: IconButton(
              icon: Icon(expanded ? Icons.expand_more: Icons.expand_less),
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
            ),
          ),
          SizedBox(height: 5,),
          if (expanded)
            Container(
              color: Colors.teal,
              height: min(widget.order.products.length * 20.0 + 100, 180),
              child: ListView(
                      children: widget.order.products
                          .map((pro) => Row(

                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    pro.title,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white
                                    ),
                                  ),
                                  Text('${pro.quantity}x \$${pro.price}',  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white),
                                  )],
                              ))
                          .toList())
            )],

              ),
            )
    ;
  }
}
