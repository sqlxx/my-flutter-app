import 'package:flutter/material.dart';

class Product {
  const Product({required this.name});
  final String name;
}

typedef void CartChangedCallback(Product product, bool inCart);

class ShoppingListItem extends StatelessWidget {
  ShoppingListItem({required this.product, required this.inCart, required this.onCartChanged})
      : super(key: ObjectKey(product));

  final Product product;
  final bool inCart;
  final CartChangedCallback onCartChanged;

  Color _getColor(BuildContext context) {
    return inCart ? Colors.black54 : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!inCart) return null;

    return TextStyle(color: Colors.black54, decoration: TextDecoration.lineThrough);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onCartChanged(product, inCart),
      leading: CircleAvatar(backgroundColor: _getColor(context), child: Text(product.name[0])),
      title: Text(product.name, style: _getTextStyle(context)),
    );
  }
}

class ShoppingList extends StatefulWidget {
  ShoppingList({required this.products});

  final List<Product> products;

  @override
  _ShoppingListState createState() {
    return _ShoppingListState();
  }
}

class _ShoppingListState extends State<ShoppingList> {
  Set<Product> _shoppingCart = Set<Product>();

  void _handleCartChanged(Product product, bool inCart) {
    setState(() {
      if (!inCart) {
        _shoppingCart.add(product);
      } else {
        _shoppingCart.remove(product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Shopping List')),
        body: ListView(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            children: widget.products.map((Product product) {
              return ShoppingListItem(
                inCart: this._shoppingCart.contains(product),
                product: product,
                onCartChanged: this._handleCartChanged,
              );
            }).toList()));
  }
}

class ShoppingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShoppingList(products: [Product(name: 'Eggs'), Product(name: 'Flour'), Product(name: 'Cholocate chips')]);
  }
}
