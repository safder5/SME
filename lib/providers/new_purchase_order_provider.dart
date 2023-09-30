import 'package:ashwani/Models/iq_list.dart';
import 'package:ashwani/Models/purchase_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _auth = FirebaseAuth.instance.currentUser;
String? uid = _auth!.email;

class NPOrderProvider with ChangeNotifier {
  final List<PurchaseOrderModel> _po = [];
  List<PurchaseOrderModel> get po => _po;

  final CollectionReference _purchaseOrderCollection = FirebaseFirestore
      .instance
      .collection('UserData')
      .doc(uid)
      .collection('orders')
      .doc('purchases')
      .collection('purchase_orders');

  Future<void> addPurchaseOrder(PurchaseOrderModel puchaseOrder) async {
    try {
      await _purchaseOrderCollection
          .doc((puchaseOrder.orderID.toString()))
          .set({
        'orderId': puchaseOrder.orderID,
        'vendor_name': puchaseOrder.vendorName,
        'purchase_date': puchaseOrder.purchaseDate,
        'delivery_date': puchaseOrder.deliveryDate,
        'notes': puchaseOrder.notes,
        'tandc': puchaseOrder.tandc,
        'payment_terms': puchaseOrder.paymentTerms,
        'delivery_method': puchaseOrder.deliveryMethod,
        'status': puchaseOrder.status,
      });
      final itemsCollection = _purchaseOrderCollection
          .doc(puchaseOrder.orderID.toString())
          .collection('items');

      for (final item in puchaseOrder.items!) {
        await itemsCollection.doc(item.itemName).set(
            {'itemName': item.itemName, 'itemQuantity': item.quantityPurchase});
      }
      notifyListeners();
    } catch (e) {
      print('error uploading purchase order');
    }
  }

  Future<void> fetchPurchaseOrders() async {
    try {
      final querySnapshot = await _purchaseOrderCollection.get();
      _po.clear();
      for (final doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final purchaseOrder = PurchaseOrderModel(
            orderID: data['orderId'],
            vendorName: data['vendor_name'],
            purchaseDate: data['purchase_date'],
            deliveryDate: data['delivery_date'],
            paymentTerms: data['payment_terms'],
            deliveryMethod: data['delivery_method'],
            notes: data['notes'],
            tandc: data['tandc'],
            status: data['status']);

        final itemCollection = doc.reference.collection('items');
        final itemDocs = await itemCollection.get();
        if (itemDocs.docs.isNotEmpty) {
          purchaseOrder.items = itemDocs.docs.map((itemDoc) {
            final itemData = itemDoc.data();
            return Item(
                itemName: itemData['itemName'],
                itemQuantity: itemData['itemQuantity']);
          }).toList();
        }
        _po.add(purchaseOrder);
      }
      notifyListeners();
    } catch (e) {
      print("Error fetching orders");
    }
  }
}
