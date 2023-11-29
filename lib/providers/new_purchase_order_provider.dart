import 'package:ashwani/Models/iq_list.dart';
import 'package:ashwani/Models/purchase_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _auth = FirebaseAuth.instance.currentUser;
String? uid = _auth!.email;

class NPOrderProvider with ChangeNotifier {
  int _toRecieve = 0;
  int get toRecieve => _toRecieve;
  final List<PurchaseOrderModel> _po = [];
  List<PurchaseOrderModel> get po => _po;
  final List<ItemTrackingPurchaseOrder> _pa = [];
  List<ItemTrackingPurchaseOrder> get pa => _pa;

  final CollectionReference _purchaseOrderCollection = FirebaseFirestore
      .instance
      .collection('UserData')
      .doc(uid)
      .collection('orders')
      .doc('purchases')
      .collection('purchase_orders');
  final _cref = FirebaseFirestore.instance
      .collection('UserData')
      .doc(uid)
      .collection('purchase_activities');

  void clearAll() {
    _po.clear();
    _pa.clear();
    notifyListeners();
  }

  void addPurchaseOrdertoProvider(PurchaseOrderModel po) {
    _po.add(po);
    notifyListeners();
  }

  void updatePurchaseActivityinProvider(ItemTrackingPurchaseOrder activity) {
    _pa.add(activity);
    notifyListeners();
  }

  void updateitemDetailsquantityinProvider(
      int orderId, String itemName, int quantity) {
    final orders = _po;
    final orderIndex = orders.indexWhere(
      (element) => element.orderID == orderId,
    );
    final order = orders[orderIndex];
    final items = order.items ?? [];
    final itemIndex =
        items.indexWhere((element) => element.itemName == itemName);
    final item = items[itemIndex];
    var q = item.originalQuantity!;
    q += quantity;
    item.originalQuantity = q;
    items[itemIndex] = item;
    order.items = items;
    _po[orderIndex] = order;
    notifyListeners();
  }

  Future<void> updateitemDetailsquantityinFireBase(
      int orderId, String itemName, int quantity) async {
    final orders = _po;
    final orderIndex = orders.indexWhere(
      (element) => element.orderID == orderId,
    );
    final order = orders[orderIndex];
    final items = order.items ?? [];
    final itemIndex =
        items.indexWhere((element) => element.itemName == itemName);
    final item = items[itemIndex];
    var q = item.originalQuantity!;
    q += quantity;
    try {
      await _purchaseOrderCollection
          .doc(orderId.toString())
          .collection('items')
          .doc(itemName)
          .update({'originalQuantity': q});
      notifyListeners();
    } catch (e) {
      print('$e updateitemDetailsquantityinFireBase Purchase');
    }
  }

  void reduceItemsDetailsQTY(int orderId, String itemName, int quantity) {
    final orders = _po;
    final orderIndex = orders.indexWhere(
      (element) => element.orderID == orderId,
    );
    final order = orders[orderIndex];
    final items = order.items ?? [];
    final itemIndex =
        items.indexWhere((element) => element.itemName == itemName);
    final item = items[itemIndex];
    var q = item.originalQuantity!;
    q -= quantity;
    item.originalQuantity = q;
    items[itemIndex] = item;
    order.items = items;
    _po[orderIndex] = order;
    notifyListeners();
  }

  Future<void> reduceItemsDetailsQtyFB(
      int orderId, String itemName, int quantity) async {
    final orders = _po;
    final orderIndex = orders.indexWhere(
      (element) => element.orderID == orderId,
    );
    final order = orders[orderIndex];
    final items = order.items ?? [];
    final itemIndex =
        items.indexWhere((element) => element.itemName == itemName);
    final item = items[itemIndex];
    var q = item.originalQuantity!;
    q -= quantity;
    try {
      await _purchaseOrderCollection
          .doc(orderId.toString())
          .collection('items')
          .doc(itemName)
          .update({'originalQuantity': q});
      notifyListeners();
    } catch (e) {
      print('$e reduceItemsDetailsQtyFB');
    }
  }

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
        await itemsCollection.doc(item.itemName).set({
          'itemName': item.itemName,
          'quantityPurchase': item.quantityPurchase,
          'originalQuantity': item.originalQuantity
        });
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
                quantityPurchase: itemData['quantityPurchase'],
                originalQuantity: itemData['originalQuantity'] ?? 0);
          }).toList();
        }

        final tracksCollection = doc.reference.collection('tracks');
        final trackDocs = await tracksCollection.get();
        if (trackDocs.docs.isNotEmpty) {
          purchaseOrder.tracks = trackDocs.docs.map((tdoc) {
            final trackData = tdoc.data();
            return ItemTrackingPurchaseOrder(
                itemName: trackData['itemName'],
                quantityRecieved: trackData['quantityRecieved'] ?? 0,
                quantityReturned: trackData['quantityReturned'] ?? 0,
                date: trackData['date'] ?? '');
          }).toList();
        }
        final itemsRecievedCollection =
            doc.reference.collection('itemsRecieved');
        final recieveDocs = await itemsRecievedCollection.get();
        if (recieveDocs.docs.isNotEmpty) {
          purchaseOrder.itemsRecieved = recieveDocs.docs.map((recieved) {
            final itemRecievedData = recieved.data();
            return ItemTrackingPurchaseOrder(
              itemName: itemRecievedData['itemName'],
              quantityRecieved: itemRecievedData['quantityRecieved'] ?? 0,
              quantityReturned: itemRecievedData['quantityReturned'] ?? 0,
            );
          }).toList();
        }
        final itemReturnedCollection = doc.reference.collection('returns');
        final itemsReturnedDocs = await itemReturnedCollection.get();
        if (itemsReturnedDocs.docs.isNotEmpty) {
          purchaseOrder.itemsReturned = itemsReturnedDocs.docs.map((e) {
            final itemReturned = e.data();
            return ItemTrackingPurchaseOrder(
              itemName: itemReturned['itemName'],
              quantityReturned: itemReturned['quantityReturned'] ?? 0,
            );
          }).toList();
        }
        _po.add(purchaseOrder);
      }
      notifyListeners();
    } catch (e) {
      print("Error fetching orders");
    }
  }

  Future<void> fetchPurchaseActivity() async {
    try {
      final snapshot = await _cref.get();
      _pa.clear();
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final purchaseActivity = ItemTrackingPurchaseOrder(
            itemName: data['itemName'],
            quantityRecieved: data['quantityRecieved'] ?? 0,
            quantityReturned: data['quantityReturned'] ?? 0,
            date: data['date'] ?? '',
            vendor: data['vendor'] ?? '');
        _pa.add(purchaseActivity);
      }
      notifyListeners();
    } catch (e) {
      print('error fetching purhcase activity $e');
    }
  }

  void updateDetailsafterReturninProvider(
      String name, int qreturned, int orderId) {
    try {
      final orderIndex =
          _po.indexWhere((element) => element.orderID == orderId);
      final order = _po[orderIndex];
      final items = order.items ?? [];
      final itemsToUpdateIndex =
          items.indexWhere((element) => element.itemName == name);
      final itemtoUpdate = items[itemsToUpdateIndex];
      final qPurchases = itemtoUpdate.quantityPurchase ?? 0;
      itemtoUpdate.quantityPurchase = qPurchases + qreturned;
      items[itemsToUpdateIndex] = itemtoUpdate;
      order.items = items;
      _po[orderIndex] = order;
      notifyListeners();
    } catch (e) {
      print('error while updating updateSalesOrderDetailsOnReturninProviders');
    }
  }

  void purchaseReturnProviderUpdate(int orderId, String itemName,
      int quantityReturned, ItemTrackingPurchaseOrder itemReturned) {
    int index = _po.indexWhere((element) => element.orderID == orderId);
    PurchaseOrderModel? foundOrder = _po[index];

    if (foundOrder.orderID != 0) {
      final itemsRecievedList = foundOrder.itemsRecieved;

      int itemIndex = itemsRecievedList!
          .indexWhere((element) => element.itemName == itemName);

      ItemTrackingPurchaseOrder itemRecieved = itemsRecievedList[itemIndex];

      itemRecieved.quantityRecieved -= quantityReturned;
      itemRecieved.quantityReturned += quantityReturned;
      itemsRecievedList[itemIndex] = itemRecieved;

      foundOrder.itemsRecieved = itemsRecievedList;

      if (foundOrder.itemsReturned == null) {
        List<ItemTrackingPurchaseOrder> itemsReturnedList = [itemReturned];
        foundOrder.itemsReturned = itemsReturnedList;
      } else {
        List<ItemTrackingPurchaseOrder> itemsReturnedList =
            foundOrder.itemsReturned!;

        try {
          int itemIndex = itemsReturnedList
              .indexWhere((element) => element.itemName == itemName);

          ItemTrackingPurchaseOrder? itemReturned =
              itemsReturnedList[itemIndex];

          itemReturned.quantityReturned += quantityReturned;
          itemsReturnedList[itemIndex] = itemReturned;

          foundOrder.itemsReturned = itemsReturnedList;
        } catch (e) {
          print('error in return $e');
          itemsReturnedList.add(itemReturned);
          foundOrder.itemsReturned = itemsReturnedList;
        }
      }
    }
    _po[index] = foundOrder;
    notifyListeners();
  }

  void purchaseRecievedProviderUpdate(int orderId, String itemName,
      int quantityRecieved, ItemTrackingPurchaseOrder itemRecieved) {
    try {
      int index = _po.indexWhere((element) => element.orderID == orderId);
      PurchaseOrderModel foundOrder = _po[index];

      if (foundOrder.orderID != 0) {
        final itemsList = foundOrder.items;
        int itemindex =
            itemsList!.indexWhere((element) => element.itemName == itemName);
        Item item = itemsList[itemindex];
        item.quantityPurchase = item.quantityPurchase! - quantityRecieved;
        itemsList[itemindex] = item;
        foundOrder.items = itemsList;

        if (foundOrder.itemsRecieved == null) {
          List<ItemTrackingPurchaseOrder> itemsRecieved = [itemRecieved];
          foundOrder.itemsRecieved = itemsRecieved;
        } else {
          List<ItemTrackingPurchaseOrder> itemsRecievedList =
              foundOrder.itemsRecieved!;
          try {
            int itemIndex = itemsRecievedList
                .indexWhere((element) => element.itemName == itemName);
            ItemTrackingPurchaseOrder? itemRecieved =
                itemsRecievedList[itemIndex];
            itemRecieved.quantityRecieved += quantityRecieved;
            itemsRecievedList[itemIndex] = itemRecieved;
            foundOrder.itemsRecieved = itemsRecievedList;
          } catch (e) {
            print('error in recieved $e');
            itemsRecievedList.add(itemRecieved);
            foundOrder.itemsRecieved = itemsRecievedList;
          }
        }
      }
      _po[index] = foundOrder;
      notifyListeners();
    } catch (e) {
      print('error in main provider update $e');
    }
  }

  void reset() {
    _pa.clear();
    _po.clear();
    notifyListeners();
  }

  void totalToBeRecieved() {
    try {
      if (_po.isNotEmpty) {
        int ttr = 0;
        int qit = 0;
        int qitr = 0;
        for (final order in po) {
          final i = order.items ?? [];
          final ir = order.itemsRecieved ?? [];
          if ( i.isNotEmpty || ir.isNotEmpty) {
            for (final item in i) {
              qit += item.originalQuantity ?? 0;
            }
            for (final itemRec in ir) {
              qitr += itemRec.quantityRecieved;
            }
            ttr = qit - qitr;
          }
        }

        // int totalToReceive = po.fold<int>(
        //   0,
        //   (previousValue, order) => order.calculateQuantityToReceive(),
        // );

        _toRecieve = ttr;
        print(_toRecieve);
        // notifyListeners();
      } else {
        print('khali hai');
      }
    } catch (e) {
      print(' yahan hai galti $e');
      _toRecieve = 0;
      // notifyListeners();
    }
  }
}


// final itemRecievedList = foundOrder.itemsRecieved;
    // ItemTrackingPurchaseOrder? itemRecieved = itemRecievedList!
    //     .firstWhere((element) => element.itemName == itemName);
    // itemRecieved.quantityRecieved += quantityRecieved;

    // final itemsList = foundOrder.items;
    // Item? item =
    //     itemsList!.firstWhere((element) => element.itemName == itemName);
    // item.itemQuantity = item.itemQuantity! - quantityRecieved;
    // _lastUpdatedPurchaseOrder = foundOrder;
    // _pa.clear();

       // ItemTrackingPurchaseOrder? itemReturned = itemReturnedList!
      //     .firstWhere((element) => element.itemName == itemName);
      // int prevReturnQuantity = itemReturned.quantityReturned;
      // itemReturned.quantityReturned += quantityReturned;

      // final itemRecievedList = foundOrder.itemsRecieved;

      // ItemTrackingPurchaseOrder? itemRecieved = itemRecievedList!
      //     .firstWhere((element) => element.itemName == itemName);

      // itemRecieved.quantityReturned += quantityReturned;

      // _lastUpdatedPurchaseOrder = foundOrder;
      // _pa.clear();