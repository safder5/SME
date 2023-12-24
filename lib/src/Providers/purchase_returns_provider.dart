import 'package:SMEflow/src/Models/iq_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../user_data.dart';



class PurchaseReturnsProvider with ChangeNotifier {
  final List<PurchaseReturnItemTracking> _pr = [];
  List<PurchaseReturnItemTracking> get pr => _pr;

  Future<void> fetchPurchaseReturns() async {
    try {
      final querySS = await FirebaseFirestore.instance
          .collection('UserData')
          .doc(UserData().userEmail)
          .collection('purchase_returns')
          .get();
      _pr.clear();
      for (final doc in querySS.docs) {
        final data = doc.data();
        final purchaseReturn = PurchaseReturnItemTracking(
          orderId: data['orderId'],
          itemname: data['itemname'],
          referenceNo: data['referenceNo'],
          date: data['date'],
          // toSeller: data[''],
          quantity: data['quantityPurchaseReturned'],
        );
        _pr.add(purchaseReturn);
      }
      _pr.reversed.toList();
      notifyListeners();
    } catch (e) {
      print('error fetching purchase returns');
    }
  }

  void addPurchaseReturninProvider(PurchaseReturnItemTracking prit) {
    _pr.add(prit);
    notifyListeners();
  }

  void reset() {
    try {
      _pr.clear();
      notifyListeners();
    } catch (e) {
      print('error pr reset');
    }
  }
}
