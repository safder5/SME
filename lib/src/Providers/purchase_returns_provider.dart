import 'package:ashwani/src/Models/iq_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _auth = FirebaseAuth.instance.currentUser;
String? uid = _auth!.email;

class PurchaseReturnsProvider with ChangeNotifier {
  final List<PurchaseReturnItemTracking> _pr = [];
  List<PurchaseReturnItemTracking> get pr => _pr;

  Future<void> fetchPurchaseReturns() async {
    try {
      final querySS = await FirebaseFirestore.instance
          .collection('UserData')
          .doc(uid)
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
    _pr.clear();
    notifyListeners();
  }
}
