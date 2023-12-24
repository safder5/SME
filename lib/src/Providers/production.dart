import 'package:ashwani/src/Models/production_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../user_data.dart';


class ProductionProvider with ChangeNotifier {
  final List<ProductionModel> _prod = [];
  List<ProductionModel> get prod => _prod;

  final CollectionReference _prodCn = FirebaseFirestore.instance
      .collection('UserData')
      .doc(UserData().userEmail)
      .collection('production');

  //c
  void addProduction(ProductionModel prod) {
    _prod.add(prod);
    notifyListeners();
  }

  Future<void> addProductiontoDB(ProductionModel prod) async {
    try {
      await _prodCn.doc(prod.productionID).set({
        'nameofBOM': prod.nameofBOM,
        'dateTime': prod.dateTime,
        'productionID': prod.productionID,
        'quantityofBOMProduced': prod.quantityofBOMProduced,
      });
    } catch (e) {
      print('$e in addProductiontoDB');
    }
  }

  //r
  //fetch production
  Future<void> fetchProductions() async {
    try {
      _prod.clear();
      final querySnap = await _prodCn.get();

      for (final doc in querySnap.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final prod = ProductionModel(
            productionID: data['productionID'],
            dateTime: data['dateTime'],
            quantityofBOMProduced: data['quantityofBOMProduced'],
            nameofBOM: data['nameofBOM']);
        _prod.add(prod);
        notifyListeners();
      }
    } catch (e) {
      print('$e fetch Productions');
    }
  }

  //u
  void updateProduction(ProductionModel prod, int index) {
    _prod[index] = prod;
    notifyListeners();
  }

  //d
  void deleteProduction(int index) {
    _prod.remove(_prod[index]);
    notifyListeners();
  }

  void reset() {
    try {
      _prod.clear();
      notifyListeners();
    } catch (e) {
      print('error prodp reset');
    }
  }
}
