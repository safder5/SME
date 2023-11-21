import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Models/bom_model.dart';

// class BOMProviders extends ChangeNotifier {}
final _auth = FirebaseAuth.instance.currentUser;
String? uid = _auth!.email;

class BOMProvider extends ChangeNotifier {
  final List<BOMmodel> _boms = [];
  final List<BOMItem> _items = [];

  List<BOMItem> get items => _items;
  List<BOMmodel> get boms => _boms;

  final CollectionReference _bomCollection = FirebaseFirestore.instance
      .collection('UserData')
      .doc(uid)
      .collection('boms');

  void addItem(BOMItem item) {
    // print('Adding $item');
    _items.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    // print("Removing ${_items[index]}");
    _items.removeAt(index);
    notifyListeners();
  }

  void clearItems() {
    _items.clear();
    notifyListeners();
  }

  void addBOMtoProv(BOMmodel bom) {
    _boms.add(bom);
    notifyListeners();
  }

  Future<void> addProductoinIDtoBOM(String productionId, String bomName) async {
    try {
      await _bomCollection
          .doc(bomName)
          .collection('productionIDs')
          .doc(productionId)
          .set({
        'productionId': productionId,
      });
    } catch (e) {
      print('$e');
    }
  }

  void addProductoinIDtoBOMProvider(String productionId, String bomName) {
    try {
      final bomIndex =
          _boms.indexWhere((element) => element.productName == bomName);
      BOMmodel bom = _boms[bomIndex];
      List<String> productionIDS = bom.productionIDs ?? [];
      productionIDS.add(productionId);
      bom.productionIDs = productionIDS;
      _boms[bomIndex] = bom;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadBOMtoDB(BOMmodel bom) async {
    try {
      await _bomCollection.doc(bom.productName).set({
        "productName": bom.productName,
        "notes": bom.notes ?? '',
        "dateCreated": FieldValue.serverTimestamp(),
        "productCode": bom.productCode,
      });
      final itemsCollection =
          _bomCollection.doc(bom.productName).collection('items');
      for (final item in bom.itemswithQuantities) {
        await itemsCollection.doc(item.itemname).set({
          "quantity": item.quantity,
          "itemname": item.itemname,
        });
      }
      notifyListeners();
    } catch (e) {
      print('Error bom upload $e');
      throw e.toString();
    }
  }

  Future<void> fetchBOMS() async {
    try {
      final querySnapshot = await _bomCollection.get();
      _boms.clear();
      for (final doc in querySnapshot.docs) {
        List<BOMItem> items = [];
        final itemsCollection = doc.reference.collection('items');
        final itemdocs = await itemsCollection.get();
        if (itemdocs.docs.isNotEmpty) {
          items = itemdocs.docs.map((idata) {
            return BOMItem(
              itemname: idata['itemname'],
              quantity: idata['quantity'],
            );
          }).toList();
        }
        final data = doc.data() as Map<String, dynamic>;
        final bom = BOMmodel(
          productName: data['productName'],
          itemswithQuantities: items,
          notes: data['notes'],
          productCode: data['productCode'],
          productionIDs: data['productionIDs']
        );
        _boms.add(bom);
      }
      notifyListeners();
    } catch (e) {
      print('$e error to hai ');
    }
  }
}
