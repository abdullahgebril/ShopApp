import 'package:flutter/material.dart';
import 'screens/prouctsScreen.dart';
import 'Provider/Products.dart';
import 'package:provider/provider.dart';
import './Provider/Cart.dart';
import './Provider/orders.dart';
import 'screens/authٍScreen.dart.dart';
import 'Provider/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
            builder: (cxt, auth, previous) =>
                Products(auth.token, previous == null ? [] : previous.items),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth,orders>(builder: (cxt,auth,previous)=>orders(auth.token,previous==null?[]: previous.itms)),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
                primarySwatch: Colors.teal, accentColor: Colors.deepOrange),
            home: auth.isAuth ? ProductsScreen() : AuthScreen(),
          ),
        ));
  }
}
