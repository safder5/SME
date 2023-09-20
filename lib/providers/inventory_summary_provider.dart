import 'package:ashwani/model/iq_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InventorySummaryProvider with ChangeNotifier {
  int _inHand = 0;
  int get inHand => _inHand;
  int _toRecieve = 0;
  int get toRecieve => _toRecieve;

  List<Item> _inventoryItems = [];

  List<Item> get inventoryItems => _inventoryItems;

  final inHandRef = FirebaseFirestore.instance
      .collection('UserData')
      .doc(FirebaseAuth.instance.currentUser?.email)
      .collection('Items');

  // another reference for to be recieved items

  Future<void> totalInHand() async {
    try {
      // sotre all items in inventory items
      final querySnapshot = await inHandRef.get();
      _inventoryItems = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Item(
          itemName: data['item_name'],
          itemQuantity: int.parse(data['sIh']),
        );
      }).toList();

      // calculate sum of all items
      _inHand = _inventoryItems
          .map((item) => item.itemQuantity ?? 0)
          .reduce((sum, quantity) => sum + quantity);
      // print(_inHand);

      notifyListeners();
    } catch (e) {
      print('Error fetching items: $e');
    }
  }

  Future<void> totalTobeRecieved() async {
    // try {
    //   // sotre all items in inventory items
    //   final querySnapshot = await inHandRef.get();
    //   _inventoryItems = querySnapshot.docs.map((doc) {
    //     final data = doc.data();
    //     return Item(
    //       itemName: data['itemName'],
    //       itemQuantity: data['itemQuantity'],
    //     );
    //   }).toList();

    //   // calculate sum of all items
    //   _inHand = _inventoryItems
    //       .map((item) => item.itemQuantity ?? 0)
    //       .reduce((sum, quantity) => sum + quantity);
    // } catch (e) {
    //   print('Error fetching items: $e');
    // }
  }
}
