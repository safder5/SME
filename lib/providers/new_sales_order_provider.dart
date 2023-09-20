import 'package:ashwani/model/sales_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/iq_list.dart';

final _auth = FirebaseAuth.instance.currentUser;
String? uid = _auth!.email;

class NSOrderProvider with ChangeNotifier {
  final List<SalesOrderModel> _so = [];

  List<SalesOrderModel> get som => _so;

  final CollectionReference _salesOrderCollection = FirebaseFirestore.instance
      .collection('UserData')
      .doc(uid)
      .collection('orders')
      .doc('sales')
      .collection('sales_orders');

  Future<void> addSalesOrder(SalesOrderModel so) async {
    try {
      final orderDoc = await _salesOrderCollection.add({
        'orderID': so.orderID,
        'customerName': so.customerName,
        'orderDate': so.orderDate,
        'shipmentDate': so.shipmentDate,
        'paymentMethods': so.paymentMethods,
        'notes': so.notes,
        'tandC': so.tandC,
        'status': so.status,
      });
      final itemsCollection = orderDoc.collection('items');

      for (final item in so.items!) {
        await itemsCollection.add({
          'itemName': item.itemName,
          'itemQuantity': item.itemQuantity,
        });
      }
      notifyListeners();
    } catch (e) {
      print("Error uploading to fb");
    }
  }

  Future<void> fetchSalesOrders() async {
    try {
      final querySnapshot = await _salesOrderCollection.get();
      _so.clear();
      for (final doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final salesOrder = SalesOrderModel(
          orderID: data['orderID'],
          customerName: data['customerName'],
          orderDate: data['orderDate'],
          shipmentDate: data['shipmentDate'],
          paymentMethods: data['paymentMethods'],
          notes: data['notes'],
          tandC: data['tandC'],
          status: data['status'],
          items: null,
        );

        final itemsCollection = doc.reference.collection('items');
        final itemDocs = await itemsCollection.get();
        if (itemDocs.docs.isNotEmpty) {
          salesOrder.items = itemDocs.docs.map((itemDoc) {
            final itemData = itemDoc.data();
            return Item(
              itemName: itemData['itemName'],
              itemQuantity: itemData['itemQuantity'],
            );
          }).toList();
        }
        _so.add(salesOrder);
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching sales orders: $e');
    }
  }

  Future<void> updateSalesOrder(
      SalesOrderModel updatedSalesOrder, int index) async {
    try {
      final salesOrderDoc = _salesOrderCollection
          .doc(_so[index].orderID.toString()); // Assuming orderID is unique
      await salesOrderDoc.update({
        'customerName': updatedSalesOrder.customerName,
        'orderDate': updatedSalesOrder.orderDate,
        'shipmentDate': updatedSalesOrder.shipmentDate,
        'paymentMethods': updatedSalesOrder.paymentMethods,
        'notes': updatedSalesOrder.notes,
        'tandC': updatedSalesOrder.tandC,
      });
      _so[index] = updatedSalesOrder;
      notifyListeners();
    } catch (e) {
      print('Error updating sales order: $e');
    }
  }

  Future<void> removeSalesOrder(int index) async {
    try {
      final orderID = _so[index].orderID;
      await _salesOrderCollection
          .doc(orderID.toString())
          .delete(); // Assuming orderID is unique
      _so.removeAt(index);
      notifyListeners();
    } catch (e) {
      print('Error removing sales order: $e');
    }
  }

  // make a function to open close status of sales order
}
