import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/Products.dart';
import '../widgets/User_product_item.dart';
import '../widgets/Appdrawer.dart';
import 'EditProductSceen.dart';

class UserProudctScreen extends StatelessWidget {

  Future<void> _refreshProducts(BuildContext context)async {
    await Provider.of<Products>(context).FetchProducts();

  }
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Your Prodcts'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProductScreen('')),
              );
            })
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: ()=>_refreshProducts(context)  ,

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (context, index) => UserProductItem(
                productsData.items[index].id,
                productsData.items[index].title,
                productsData.items[index].imageUrl,

            ),
          ),
        ),
      ),
    );
  }
}
