import 'package:flutter/foundation.dart';
import './catalog.dart';

class CartModel extends ChangeNotifier {
  CatalogModel? _catalog;

  final List<int> _itemIds = [];

  CatalogModel? get catalog => _catalog;

  set catalog(CatalogModel? newCatalog) {
    _catalog = newCatalog;
    notifyListeners();
  }

  List<Item> get items => _itemIds.map((id) => _catalog!.getById(id)).toList();

  int get totalPrice => items.fold(0, (total, current) => total + current.price);

  void add(Item item) {
    _itemIds.add(item.id);

    notifyListeners();
  }
}
