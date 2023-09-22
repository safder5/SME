import 'package:ashwani/Models/iq_list.dart';
import 'package:flutter/material.dart';

class ItemsProvider with ChangeNotifier {
  List<Item> _items = [];

  List<Item> get items => _items;

  void addItem(Item newItem) {
    _items.add(newItem);
    notifyListeners();
  }

  void updateItem(int index, Item updatedItem) {
    _items[index] = updatedItem;
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clearItems() {
    _items.clear();
    notifyListeners();
  }
}
