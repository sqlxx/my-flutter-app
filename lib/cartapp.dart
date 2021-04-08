import 'package:flutter/material.dart';
import 'package:my_app/screens/catalog.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';
import 'models/catalog.dart';
import 'screens/cart.dart';

class CartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(create: (context) => CatalogModel()),
          ChangeNotifierProxyProvider<CatalogModel, CartModel>(
              create: (context) => CartModel(),
              update: (context, catalog, cart) {
                cart!.catalog = catalog;
                return cart;
              })
        ],
        child: MaterialApp(
            title: 'Welcome to Flutter',
            theme: new ThemeData(primaryColor: Colors.blue),
            initialRoute: '/catalog',
            routes: {"/cart": (context) => MyCart(), "/catalog": (context) => MyCatalog()}));
  }
}
