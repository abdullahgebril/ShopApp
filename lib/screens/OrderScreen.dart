import 'package:flutter/material.dart';
import 'package:shop_app/widgets/Appdrawer.dart';
import '../Provider/orders.dart';
import 'package:provider/provider.dart';
import '../widgets/OrderItem.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isinit = true;
  var _loading = false;

  @override
  void didChangeDependencies() {
    if (_isinit) {
      setState(() {
        _loading = true;
      });
      Provider.of<orders>(context).fetchOrders().then((_) {
        _loading = false;
      });
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Order'),
      ),
      drawer: AppDrawer(),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: order.itms.length,
              itemBuilder: (context, index) => OrderItem(order.itms[index]),
            ),
    );
  }
}
