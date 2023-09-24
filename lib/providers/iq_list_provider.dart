import 'package:ashwani/Models/iq_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ItemsProvider with ChangeNotifier {
  List<Item> _items = [];
  List<Item> _poItems = [];

  List<Item> get items => _items;
  List<Item> get poItems => _poItems;

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

  Future<void> getItems() async {
    try {
      final auth = FirebaseAuth.instance.currentUser;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('UserData')
          .doc(auth!.email)
          .collection('Items') // Replace with your Firestore collection name
          .get();

      _poItems.clear();
      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final item = Item(
          itemName: data['item_name'],
          itemQuantity:int.parse(data['sIh']),
        );
        _poItems.add(item);
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching items: $e');
    }
  }

  List<String?> getItemNames() {
    return _poItems.map((item) => item.itemName).toList();
  }
}
