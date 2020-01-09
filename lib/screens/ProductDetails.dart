



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/Products.dart';

import '../Provider/Product.dart';


class ProductDetailsScreen extends StatelessWidget {
  String productid;
  ProductDetailsScreen(this.productid);



  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    final selectedproduct = products.items.firstWhere((pro)=> pro.id == productid);
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.8),
        appBar: AppBar(
          title: Text(selectedproduct.title),

        ),
        body:Column(
          children: <Widget>[
            Container(
              height: 400,
              width: double.infinity,
              child: Image.network(selectedproduct.imageUrl,fit: BoxFit.cover,),
            ),
            SizedBox(height: 15,),
            Text('${selectedproduct.title}',style: TextStyle(color: Colors.black54,fontSize: 40),),
            SizedBox(height: 10,),
            Text('${selectedproduct.description}',style: TextStyle(color: Colors.black54,fontSize: 40),softWrap: true,textAlign: TextAlign.center,),
          ],
        )
    );
}






}



