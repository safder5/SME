import 'package:ashwani/Models/bom_model.dart';
import 'package:ashwani/Models/iq_list.dart';
import 'package:ashwani/Models/item_tracking_model.dart';
import 'package:ashwani/Models/production_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ItemsProvider with ChangeNotifier {
  final List<Item> _soItems = [];
  final List<Item> _allItems = [];
  final List<Item> _poItems = [];
  final List<Item> _salesDelivered = [];

  List<Item> get soItems => _soItems;
  List<Item> get allItems => _allItems;
  List<Item> get poItems => _poItems;
  List<Item> get salesDelivered => _salesDelivered;

  final _auth = FirebaseAuth.instance.currentUser;
  final _fs = FirebaseFirestore.instance;

  void addInvItemtoProvider(Item item, ItemTrackingModel track) {
    Item i = item;
    i.itemTracks = [track];
    _allItems.add(i);
  }

  Future<void> stockAdjustinFB(
      int newQuantity, String itemName, DateTime now, int trackQ) async {
    try {
      DocumentReference dRef = _fs
          .collection('UserData')
          .doc('${_auth!.email}')
          .collection('Items')
          .doc(itemName);
      dRef.update({'itemQuantity': newQuantity});
      await dRef
          .collection('tracks')
          .doc(now.millisecondsSinceEpoch.toString())
          .set({
        "orderID": now.millisecondsSinceEpoch.toString(),
        'quantity': trackQ,
        'reason': 'Stock Adjustment',
      });
      notifyListeners();
    } catch (e) {
      print('error uploading stokc adjust $e');
    }
  }

  void stockAdjustinProvider(
      int newQuantity, String itemName, DateTime now, int trackQ) {
    try {
      int index =
          _allItems.indexWhere((element) => element.itemName == itemName);
      final item = _allItems[index];
      item.itemQuantity = newQuantity;
      var tracks = item.itemTracks ?? [];
      tracks.add(ItemTrackingModel(
          orderID: now.millisecondsSinceEpoch.toString(),
          quantity: trackQ,
          reason: 'Stock Adjustment'));
      item.itemTracks = tracks;
      _allItems[index] = item;
      notifyListeners();
    } catch (e) {
      print('$e');
    }
  }

  void updateItemsonSalesTransactioninProvider(
      String itemName, int quantityShipped) {
    final index =
        _allItems.indexWhere((element) => element.itemName == itemName);
    final item = _allItems[index];
    final quantity = item.itemQuantity! - quantityShipped;
    item.itemQuantity = quantity;
    final sales = item.quantitySales! - quantityShipped;
    item.quantitySales = sales;
    _allItems[index] = item;
    notifyListeners();
  }

  void updateItemsonPurchaseTransactioninProvider(
      String itemName, int quantityRecieved) {
    final index =
        _allItems.indexWhere((element) => element.itemName == itemName);
    final item = _allItems[index];
    final quantity = item.itemQuantity! + quantityRecieved;
    item.itemQuantity = quantity;
    final purchase = item.quantityPurchase! - quantityRecieved;
    item.quantityPurchase = purchase;
    _allItems[index] = item;
    notifyListeners();
  }

  void updateItemsonSalesReturninProvider(
      String itemName, int quantityReturned) {
    final index =
        _allItems.indexWhere((element) => element.itemName == itemName);
    final item = _allItems[index];
    final quantity = item.itemQuantity! + quantityReturned;
    item.itemQuantity = quantity;
    _allItems[index] = item;
    notifyListeners();
  }

  void updateItemsonPurchaseReturninProvider(
    String itemName,
    int quantityReturned,
  ) {
    final index =
        _allItems.indexWhere((element) => element.itemName == itemName);
    final item = _allItems[index];
    final quantity = item.itemQuantity! - quantityReturned;
    item.itemQuantity = quantity;
    _allItems[index] = item;
    notifyListeners();
  }

  void addItemtrackinProvider(ItemTrackingModel track, String itemName) {
    final index =
        _allItems.indexWhere((element) => element.itemName == itemName);
    final item = _allItems[index];
    final tracks = item.itemTracks ?? [];
    tracks.add(track);
    item.itemTracks = tracks;
    _allItems[index] = item;
    notifyListeners();
  }

  void updateItemAsBOMinProvider(String itemName) {
    final index =
        _allItems.indexWhere((element) => element.itemName == itemName);
    final item = _allItems[index];
    item.bom = true;
    _allItems[index] = item;
    notifyListeners();
  }

  Future<void> updateItemAsBOMtoFirebase(String itemName) async {
    DocumentReference collRef = _fs
        .collection('UserData')
        .doc('${_auth!.email}')
        .collection('Items')
        .doc(itemName);

    await collRef.update({"bom": true});
  }

  List<Item> getProductionItems(final List<BOMItem> bomitems) {
    List<Item> items = [];
    for (final i in bomitems) {
      final item =
          _allItems.firstWhere((element) => element.itemName == i.itemname);
      items.add(item);
    }
    return items;
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
          itemTracks: [],
          imageURL: data['imageURL'],
          bom: data['bom'],
          unitType: data['unitType']
        );

        final trackSnapshot = await doc.reference.collection('tracks').get();
        for (final trackDoc in trackSnapshot.docs) {
          final trackData = trackDoc.data();
          final itemTrack = ItemTrackingModel(
              orderID: trackData['orderID'],
              quantity: trackData['quantity'],
              reason: trackData['reason']);
          item.itemTracks!.add(itemTrack);
        }
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
        'bom': false,
        'imageURL': item.imageURL,
        'unitType':item.unitType
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

  Future<void> addBOMProducttoFBasItem(
      Item item, CollectionReference collRef) async {
    try {
      await collRef.doc(item.itemName.toString()).set({
        'itemName': item.itemName,
        'itemQuantity': item.itemQuantity,
        'quantityPurchase': item.quantityPurchase,
        'quantitySales': item.quantitySales,
        'bom': item.bom,
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
          orderID: orderId,
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
          orderID: orderId, quantity: updatedItem.quantitySales, reason: 'so');

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

  Future<void> makeProductionReductions(
      List<CombinedItem> cd, int qop, String productionID) async {
    final auth = FirebaseAuth.instance.currentUser;
    CollectionReference cr = FirebaseFirestore.instance
        .collection('UserData')
        .doc(auth!.email)
        .collection('Items');
    for (final item in cd) {
      try {
        final fq =
            item.itemQuantity! - (qop * item.bomQuantity); //final quantity
        await cr.doc(item.itemName).update({
          'itemQuantity': fq,
        });
        await cr.doc(item.itemName).collection('tracks').doc(productionID).set({
          'orderID': productionID,
          'quantity': qop * item.bomQuantity,
          'reason': 'Production of ${item.itemName}',
        });
      } catch (e) {
        print('error while makeProductionReductions $e');
      }
    }
    notifyListeners();
  }

  void makeProductionReductionsProvider(
      List<CombinedItem> cd, int qop, String productionID) {
    for (final item in cd) {
      try {
        final ItemTrackingModel track = ItemTrackingModel(
            orderID: productionID,
            quantity: qop * item.bomQuantity,
            reason: 'Production of ${item.itemName}');
        final it = _allItems
            .indexWhere((element) => element.itemName == item.itemName);
        var ii = _allItems[it];
        ii.itemQuantity = item.itemQuantity! - (qop * item.bomQuantity);
        List<ItemTrackingModel> t = ii.itemTracks ?? [];
        t.add(track);
        ii.itemTracks = t;
        _allItems[it] = ii;
      } catch (e) {
        print('error in makeProductionReductionsProvider $e');
      }
    }
    notifyListeners();
  }

  Future<void> updateItemProduced(String itemname, int finalquantity) async {
    try {
      await _fs
          .collection('UserData')
          .doc('${_auth!.email}')
          .collection('Items')
          .doc(itemname)
          .update({'itemQuantity': finalquantity});
    } catch (e) {
      print('$e trying updateItemProduced');
    }
  }

  void updateItemProducedinProv(String itemname, int finalquantity) {
    try {
      final i = _allItems.indexWhere((element) => element.itemName == itemname);
      Item item = _allItems[i];
      item.itemQuantity = finalquantity;
      _allItems[i] = item;
      notifyListeners();
    } catch (e) {
      print('$e trying updateItemProducedinProv');
    }
  }

  Future<void> addSOItemstoFB(CollectionReference collRef) async {}

  List<String> getItemNames() {
    return _allItems.map((item) => item.itemName).toList();
  }

  Future<void> addSalesDeliveredItemsToFirebase(
      CollectionReference collRef) async {}

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

  void addsditem(Item newSDtem) {
    _salesDelivered.add(newSDtem);
    notifyListeners();
  }

  void updatesdItem(int index, Item updatedItem) {
    _salesDelivered[index] = updatedItem;
    notifyListeners();
  }

  void removesdItem(int index) {
    _salesDelivered.removeAt(index);
    notifyListeners();
  }

  void clearsdItems() {
    _salesDelivered.clear();
    notifyListeners();
  }

  void reset() {
    _allItems.clear();
    _poItems.clear();
    _soItems.clear();
    _salesDelivered.clear();
    notifyListeners();
  }
}
