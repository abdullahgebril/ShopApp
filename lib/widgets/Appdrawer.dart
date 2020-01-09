



import 'package:flutter/material.dart';
import '../screens/prouctsScreen.dart';
import '../screens/OrderScreen.dart';
import '../screens/UserProductScreen.dart';
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text(' Orders'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop,color: Colors.teal,),
            title: Text('Shop'),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductsScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment,color: Colors.teal,),
            title: Text('orders'),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit,color: Colors.teal,),
            title: Text('Edit Products'),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProudctScreen()),
              );
            },
          )
        ],
      ),
    );
  }
}
