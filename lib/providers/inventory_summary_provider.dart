import 'package:ashwani/Models/iq_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InventorySummaryProvider with ChangeNotifier {
  int _inHand = 0;
  int _toRecieve = 0;
  List<Item> _inventoryItems = [];
  final List<Item> _purchaseOrderItems = [];

  int get inHand => _inHand;
  int get toRecieve => _toRecieve;
  List<Item> get inventoryItems => _inventoryItems;
  List<Item> get purchaseOrderItems => _purchaseOrderItems;

  final inHandRef = FirebaseFirestore.instance
      .collection('UserData')
      .doc(FirebaseAuth.instance.currentUser?.email)
      .collection('Items');

  // another reference for to be recieved items
  final tobeRecieved = FirebaseFirestore.instance
      .collection('UserData')
      .doc(FirebaseAuth.instance.currentUser?.email)
      .collection('orders')
      .doc('purchases')
      .collection('purchase_orders');

  void clearAll() {
    _inHand = 0;
    _toRecieve = 0;
    _inventoryItems.clear();
    _purchaseOrderItems.clear();
    notifyListeners();
  }

  Future<void> totalInHand() async {
    try {
      // sotre all items in inventory items
      final querySnapshot = await inHandRef.get();
      if (querySnapshot.docs.isNotEmpty) {
        _inventoryItems = querySnapshot.docs.map((doc) {
          final data = doc.data();
          return Item(
            itemName: data['itemName'],
            itemQuantity: data['itemQuantity'],
          );
        }).toList();

        // calculate sum of all items
        _inHand = _inventoryItems
            .map((item) => item.itemQuantity ?? 0)
            .reduce((sum, quantity) => sum + quantity);
        // print(_inHand);}
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching in hand items: $e');
    }
  }

  void reset() {
    _toRecieve = 0;
    _inHand = 0;
    _inventoryItems.clear();
    _purchaseOrderItems.clear();
    notifyListeners();
  }

  // do it using providers data

  // Future<void> totalTobeRecieved() async {
  //   try {
  //     // sotre all items in inventory items
  //     final querySnapshot = await tobeRecieved.get();
  //     for (final doc in querySnapshot.docs) {
  //       final itemsCollection = doc.reference.collection('itemsRecieved');
  //       final itemDocs = await itemsCollection.get();
  //       for (final itemDoc in itemDocs.docs) {
  //         final itemData = itemDoc.data();
  //         if (itemData['quantityRecieved'] != null && itemData['quantityRecieved'] is int) {
  //         final quantityPurchase = itemData['quantityRecieved'] - itemData['quantityRecieved'] as int;
  //         _toRecieve += quantityPurchase;
  //       } else {
  //         // Handle the case when 'itemQuantity' is null or not an integer
  //         print('Invalid or null itemQuantity for document: ${itemDoc.id}');
  //       }
  //       }
  //     }
  //     notifyListeners();
  //   } catch (e) {
  //     print('Error fetching : $e');
  //   }
  // }

  
}
