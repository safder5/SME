import 'package:SMEflow/src/Models/iq_list.dart';
import 'package:SMEflow/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class SalesReturnsProvider with ChangeNotifier {
  final List<SalesReturnItemTracking> _sr = [];
  List<SalesReturnItemTracking> get sr => _sr;

  Future<void> fetchSalesReturns() async {
    try {
      final querySS = await FirebaseFirestore.instance
          .collection('UserData')
          .doc(UserData().userEmail)
          .collection('sales_returns')
          .get();
      _sr.clear();
      for (final doc in querySS.docs) {
        final data = doc.data();
        final salesReturn = SalesReturnItemTracking(
          orderId: data['orderId'],
          itemname: data['itemname'],
          referenceNo: data['referenceNo'],
          date: data['date'],
          toInventory: data['toInventory'],
          quantitySalesReturned: data['quantitySalesReturned'],
        );
        print(data['itemname']);
        _sr.add(salesReturn);
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching sales returns $e');
    }
  }

  // void clearSalesReturns() {
  //   _sr.clear();
  //   notifyListeners();
  // }

  void addSalesReturninProvider(SalesReturnItemTracking ret) {
    _sr.add(ret);
    notifyListeners();
  }

  void reset() {
    try {
      _sr.clear();
      notifyListeners();
    } catch (e) {
      print('error sr reset');
    }
  }
}
