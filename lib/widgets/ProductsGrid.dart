import 'package:flutter/material.dart';

import 'package:shop_app/widgets/ProductItem.dart';
import 'package:provider/provider.dart';
import '../Provider/Products.dart';

class ProductsGrid extends StatelessWidget {

  ProductsGrid();
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final productitem = productsData.items;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 20,
      ),
      itemCount: productitem.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: productitem[index],
        child: ProductItem(

//        id: productitem[index].id,
//        imageUrl: productitem[index].imageUrl,
//        title: productitem[index].title,

            ),
      ),
    );
  }
}
