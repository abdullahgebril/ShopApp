



import 'package:flutter/material.dart';
import '../Provider/Cart.dart';
import 'package:provider/provider.dart';

class Cartitem extends StatelessWidget {
  final String id;
  final String  productId;
  final String title;
  final double price;
  final int quantity;
  Cartitem(this.id,this.productId,this.title,this.quantity,this.price);
  @override
  Widget build(BuildContext context) {
    
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete,color: Colors.white,size: 40,),alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 10),
        margin: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (dircation){
        return showDialog(context: context,builder: (context)=>AlertDialog(
          title: Text('Are you sure!?'),
          content: Text('Do you want remove item from cart?'),
          actions: <Widget>[
            FlatButton(child: Text('NO'),onPressed: (){
              Navigator.of(context).pop(false);

            },),
            FlatButton(child: Text('YES'),onPressed: (){
              Navigator.of(context).pop(true);

            },),
          ],

        )) ;

      },
      onDismissed: (dir){
        final cart = Provider.of<Cart>(context).removeItem(productId);
      },

      child: Card(
        margin: EdgeInsets.all(10),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(child: Text('\$$price')),

            ),
            title: Text(title),
            subtitle: Text('${price*quantity}'),
            trailing: Text('$quantity x'),

          ),
        ),
      ),
    );
  }
}
