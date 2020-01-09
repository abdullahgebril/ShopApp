import 'package:flutter/material.dart';
import 'package:shop_app/Provider/Cart.dart';
import 'package:shop_app/widgets/Appdrawer.dart';
import 'package:shop_app/widgets/ProductsGrid.dart';
import 'package:provider/provider.dart';
import '../Provider/Products.dart';
import '../widgets/badge.dart';
import 'CartScreen.dart';

enum FliterOptions { favorite, all }

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  // var favoriteOnly = false;
  var _isinit = true;
  var _isloading = false;
  void didChangeDependencies() {
    if (_isinit) {
      setState(() {
        _isloading = true;
      });
      Provider.of<Products>(context).FetchProducts().then((_) {
        setState(() {
          _isloading = false;
        });
      });
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final selectedProduct = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Market App'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FliterOptions selectedValue) {
              if (selectedValue == FliterOptions.favorite) {
                selectedProduct.showfavoriteOnly();
              } else {
                selectedProduct.showAll();
              }
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                  child: Text('Show Favorite'), value: FliterOptions.favorite),
              PopupMenuItem(child: Text('Show All'), value: FliterOptions.all)
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()),
                );
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: _isloading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ProductsGrid(),
      ),
    );
  }
}
