import 'package:ashwani/Models/iq_list.dart';
import 'package:ashwani/Models/item_tracking_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ItemsProvider with ChangeNotifier {
  List<Item> _soItems = [];
  List<Item> _allItems = [];
  List<Item> _poItems = [];

  List<Item> get soItems => _soItems;
  List<Item> get allItems => _allItems;
  List<Item> get poItems => _poItems;

  void addsoItem(Item newItem) {
    _soItems.add(newItem);
    notifyListeners();
  }

  void updatesoItem(int index, Item updatedItem) {
    _soItems[index] = updatedItem;
    notifyListeners();
  }

  void removesoItem(int index) {
    _soItems.removeAt(index);
    notifyListeners();
  }

  void clearsoItems() {
    _soItems.clear();
    notifyListeners();
  }

  void addpoitem(Item newPItem) {
    _poItems.add(newPItem);
    notifyListeners();
  }

  void updatepoItem(int index, Item updatedItem) {
    _poItems[index] = updatedItem;
    notifyListeners();
  }

  void removepoItem(int index) {
    _poItems.removeAt(index);
    notifyListeners();
  }

  void clearpoItems() {
    _poItems.clear();
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

      _allItems.clear();
      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final item = Item(
          itemName: data['itemName'],
          itemQuantity: data['itemQuantity'],
          quantityPurchase: data['quantityPurchase'],
          quantitySales: data['quantitySales'],
        );
        _allItems.add(item);
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching items: $e');
    }
  }

  Future<void> addItemtoFB(Item item, CollectionReference collRef) async {
    try {
      await collRef.doc(item.itemName.toString()).set({
        'itemName': item.itemName,
        'itemQuantity': item.itemQuantity,
        'quantityPurchase': item.quantityPurchase,
        'quantitySales': item.quantitySales,
      });

      CollectionReference cr =
          collRef.doc(item.itemName.toString()).collection('tracks');

      final id = item.itemTracks?[0].orderID;
      await cr.doc(id).set({
        "orderID": item.itemTracks![0].orderID,
        'quantity': item.itemTracks![0].quantity,
        'reason': item.itemTracks![0].reason,
      });
      notifyListeners();
    } catch (e) {
      print('error uploading item to fb $e');
    }
  }

  Future<void> updateItemsPOandTrack(final String orderId) async {
    for (final updatedItem in _poItems) {
      final existingItem = _allItems.firstWhere(
        (element) => element.itemName == updatedItem.itemName,
      );
      final quantityPurchaseTotal =
          updatedItem.quantityPurchase! + existingItem.quantityPurchase!;
      final ItemTrackingModel track = ItemTrackingModel(
          orderID: existingItem.itemName,
          quantity: updatedItem.quantityPurchase,
          reason: 'po');

      try {
        final auth = FirebaseAuth.instance.currentUser;
        await FirebaseFirestore.instance
            .collection('UserData')
            .doc(auth!.email)
            .collection('Items')
            .doc(updatedItem.itemName)
            .update({
          'quantityPurchase': quantityPurchaseTotal,
        });
        await FirebaseFirestore.instance
            .collection('UserData')
            .doc(auth.email)
            .collection('Items')
            .doc(updatedItem.itemName)
            .collection('tracks')
            .doc(orderId)
            .set({
          'orderID': track.orderID,
          'quantity': track.quantity,
          'reason': track.reason,
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> updateItemsSOandTrack(final String orderId) async {
    for (final updatedItem in _soItems) {
      final existingItem = _allItems.firstWhere(
        (element) => element.itemName == updatedItem.itemName,
      );
      final quantitySalesTotal =
          updatedItem.quantitySales! + existingItem.quantitySales!;
      final ItemTrackingModel track = ItemTrackingModel(
          orderID: existingItem.itemName,
          quantity: updatedItem.quantitySales,
          reason: 'so');

      try {
        final auth = FirebaseAuth.instance.currentUser;
        await FirebaseFirestore.instance
            .collection('UserData')
            .doc(auth!.email)
            .collection('Items')
            .doc(updatedItem.itemName)
            .update({
          'quantitySales': quantitySalesTotal,
        });
        await FirebaseFirestore.instance
            .collection('UserData')
            .doc(auth.email)
            .collection('Items')
            .doc(updatedItem.itemName)
            .collection('tracks')
            .doc(orderId)
            .set({
          'orderID': track.orderID,
          'quantity': track.quantity,
          'reason': track.reason,
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> addSOItemstoFB(CollectionReference collRef) async {}

  List<String?> getItemNames() {
    return _allItems.map((item) => item.itemName).toList();
  }
}
