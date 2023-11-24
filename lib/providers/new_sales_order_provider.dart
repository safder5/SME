import 'package:ashwani/Models/sales_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Models/iq_list.dart';

final _auth = FirebaseAuth.instance.currentUser;
String? uid = _auth!.email;

class NSOrderProvider with ChangeNotifier {
  final List<SalesOrderModel> _so = [];
  final List<ItemTrackingSalesOrder> _sa = [];

  List<SalesOrderModel> get som => _so;
  List<ItemTrackingSalesOrder> get sa => _sa;

  final CollectionReference _salesOrderCollection = FirebaseFirestore.instance
      .collection('UserData')
      .doc(uid)
      .collection('orders')
      .doc('sales')
      .collection('sales_orders');

  final activityRef = FirebaseFirestore.instance
      .collection('UserData')
      .doc(uid)
      .collection('sales_activities');

  // void clearAll() {
  //   _so.clear();
  //   _sa.clear();
  //   notifyListeners();
  // }

  void updateSalesActivityinProvider(ItemTrackingSalesOrder activity) {
    _sa.add(activity);
    notifyListeners();
  }

  void resetProviderToInitialState() {
    _so.clear(); // Clear the _so list

    // Optionally, you can also reset other variables if needed
    _sa.clear();

    notifyListeners();
  }

  Future<void> deleteSalesOrderFB(int orderId) async {
    try {
      await _salesOrderCollection.doc(orderId.toString()).delete();
      notifyListeners();
    } catch (e) {
      print('$e');
    }
  }

  void deleteSO(int orderId) {
    final orders = _so;
    final orderIndex = orders.indexWhere(
      (element) => element.orderID == orderId,
    );
    _so.removeAt(orderIndex);
    notifyListeners();
  }

  void updateitemDetailsquantityinProvider(
      int orderId, String itemName, int quantity) {
    final orders = _so;
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
    _so[orderIndex] = order;
    notifyListeners();
  }

  Future<void> updateitemDetailsquantityinFireBase(
      int orderId, String itemName, int quantity) async {
    final orders = _so;
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
      await _salesOrderCollection
          .doc(orderId.toString())
          .collection('items')
          .doc(itemName)
          .update({'originalQuantity': q});
      notifyListeners();
    } catch (e) {
      print('$e updateitemDetailsquantityinFireBase');
    }
  }

  void reduceItemsDetailsQuantity(int orderId, String itemName, int quantity) {
    final orders = _so;
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
    _so[orderIndex] = order;
    notifyListeners();
  }

  Future<void> reduseItemsDetailsQuantityFB(
      int orderId, String itemName, int quantity) async {
    final orders = _so;
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
      await _salesOrderCollection
          .doc(orderId.toString())
          .collection('items')
          .doc(itemName)
          .update({'originalQuantity': q});
      notifyListeners();
    } catch (e) {
      print('$e updateitemDetailsquantityinFireBase');
    }
  }

  void removeSalesItementirely(
    int orderId,
    String itemName,
  ) {
    final orders = _so;
    final orderIndex = orders.indexWhere(
      (element) => element.orderID == orderId,
    );
    final order = orders[orderIndex];
    final items = order.items ?? [];
    final itemIndex =
        items.indexWhere((element) => element.itemName == itemName);
    items.removeAt(itemIndex);
    order.items = items;
    _so[orderIndex] = order;
    notifyListeners();
  }

  Future<void> removeSOItemEntirelyFB(
    int orderId,
    String itemName,
  ) async {
    try {
      await _salesOrderCollection
          .doc(orderId.toString())
          .collection('items')
          .doc(itemName)
          .delete();
      notifyListeners();
    } catch (e) {
      print('$e updateitemDetailsquantityinFireBase');
    }
  }

  void addSalesOrderInProvider(
    SalesOrderModel so,
  ) {
    try {
      if (so.orderID != null && so.items != null) {
        _so.add(so);
        print('added items');
        // _lastUpdatedSalesOrder = so;
      }
      notifyListeners();
    } catch (e) {
      print('error in adding sales order to provider');
    }
  }

  void updateSalesOrderDetailsOnReturninProviders(
      String name, int qreturned, int orderId) {
    try {
      final orderIndex =
          _so.indexWhere((element) => element.orderID == orderId);
      final order = _so[orderIndex];
      final items = order.items ?? [];
      final itemsToUpdateIndex =
          items.indexWhere((element) => element.itemName == name);
      final itemtoUpdate = items[itemsToUpdateIndex];
      final qSales = itemtoUpdate.quantitySales ?? 0;
      itemtoUpdate.quantitySales =
          qSales + qreturned > itemtoUpdate.originalQuantity!
              ? itemtoUpdate.originalQuantity!
              : qSales + qreturned;
      // itemtoUpdate.quantitySales = qSales + qreturned;
      items[itemsToUpdateIndex] = itemtoUpdate;
      order.items = items;
      _so[orderIndex] = order;
      notifyListeners();
    } catch (e) {
      print('error while updating updateSalesOrderDetailsOnReturninProviders');
    }
  }

  Future<void> addSalesOrder(SalesOrderModel so) async {
    try {
      await _salesOrderCollection.doc(so.orderID.toString()).set({
        'orderID': so.orderID,
        'customerName': so.customerName,
        'orderDate': so.orderDate,
        'shipmentDate': so.shipmentDate,
        'paymentMethods': so.paymentMethods,
        'notes': so.notes,
        'tandC': so.tandC,
        'status': so.status,
      });
      final itemsCollection =
          _salesOrderCollection.doc(so.orderID.toString()).collection('items');

      for (final item in so.items!) {
        await itemsCollection.doc(item.itemName).set({
          'itemName': item.itemName,
          'quantitySales': item.quantitySales,
          'originalQuantity': item.originalQuantity
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
        );

        final itemsCollection = doc.reference.collection('items');
        final itemDocs = await itemsCollection.get();
        if (itemDocs.docs.isNotEmpty) {
          salesOrder.items = itemDocs.docs.map((itemDoc) {
            final itemData = itemDoc.data();
            return Item(
                itemName: itemData['itemName'],
                itemQuantity: itemData['itemQuantity'],
                quantityPurchase: itemData['quantityPurchase'],
                quantitySales: itemData['quantitySales'],
                originalQuantity: itemData['originalQuantity'] ?? 0);
          }).toList();
        }
        final tracksCollection = doc.reference.collection('tracks');
        final trackDocs = await tracksCollection.get();
        if (trackDocs.docs.isNotEmpty) {
          salesOrder.tracks = trackDocs.docs.map((trackDoc) {
            final trackData = trackDoc.data();
            return ItemTrackingSalesOrder(
                itemName: trackData['itemName'],
                quantityReturned: trackData['quantityReturned'] ?? 0,
                quantityShipped: trackData['quantityShipped'] ?? 0,
                date: trackData['date'] ?? '');
          }).toList();
        }
        final itemsDeliveredCollection =
            doc.reference.collection('itemsDelivered');
        final itemDeliveredDocs = await itemsDeliveredCollection.get();
        if (itemDeliveredDocs.docs.isNotEmpty) {
          salesOrder.itemsDelivered = itemDeliveredDocs.docs.map((e) {
            final itemDeliveredData = e.data();
            return Item(
                itemName: itemDeliveredData['itemName'],
                quantitySalesDelivered:
                    itemDeliveredData['quantitySalesDelivered'],
                quantitySalesReturned:
                    itemDeliveredData['quantitySalesReturned'] ?? 0);
          }).toList();
        }
        final salesReturnsCollection = doc.reference.collection('returns');
        final salesReturnsDocs = await salesReturnsCollection.get();
        if (salesReturnsDocs.docs.isNotEmpty) {
          salesOrder.itemsReturned = salesReturnsDocs.docs.map((e) {
            final itemReturned = e.data();
            return Item(
                itemName: itemReturned['itemName'],
                quantitySalesReturned: itemReturned['quantitySalesReturned']);
          }).toList();
        }
        _so.add(salesOrder);
      }
      // for (int i = 0; i < _so.length; i++) {
      //   print(_so[i].orderID);
      // }
      // _so.reversed;
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

  Future<void> fetchActivity() async {
    try {
      final snapshot = await activityRef.get();
      _sa.clear();
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final salesActivity = ItemTrackingSalesOrder(
          itemName: data['itemName'],
          quantityReturned: data['quantityReturned'] ?? 0,
          quantityShipped: data['quantityShipped'] ?? 0,
          date: data['date'],
          customer: data['customer'],
        );
        _sa.add(salesActivity);
      }
      notifyListeners();
    } catch (e) {
      print('Error loading sales Activity $e');
    }
  }

  void updateSalesItemsDeliveredProviders(
      int orderId, String itemName, int quantitydelivered, Item itemDelivered) {
    int index = _so.indexWhere((element) => element.orderID == orderId);
    SalesOrderModel foundOrder = _so[index];

    if (foundOrder.orderID != 0) {
      final itemsList = foundOrder.items;
      int itemindex =
          itemsList!.indexWhere((element) => element.itemName == itemName);
      Item item = itemsList[itemindex];
      item.quantitySales = item.quantitySales! - quantitydelivered;
      itemsList[itemindex] = item;
      foundOrder.items = itemsList;

      if (foundOrder.itemsDelivered == null) {
        List<Item> itemDeliveredList = [itemDelivered];
        foundOrder.itemsDelivered = itemDeliveredList;
      } else {
        List<Item> itemDeliveredList = foundOrder.itemsDelivered!;
        try {
          int itemIndex = itemDeliveredList
              .indexWhere((element) => element.itemName == itemName);
          Item? itemDelivered = itemDeliveredList[itemIndex];
          itemDelivered.quantitySalesDelivered =
              itemDelivered.quantitySalesDelivered! + quantitydelivered;
          itemDeliveredList[itemIndex] = itemDelivered;
          foundOrder.itemsDelivered = itemDeliveredList;
        } catch (e) {
          itemDeliveredList.add(itemDelivered);
          foundOrder.itemsDelivered = itemDeliveredList;
        }
      }
    }
    _so[index] = foundOrder;
    notifyListeners();
  }

  void updateSalesItemsReturnedProviders(
    int orderId,
    String itemName,
    int quantityReturned,
    Item itemReturned,
  ) {
    int index = _so.indexWhere((element) => element.orderID == orderId);
    SalesOrderModel foundOrder = _so[index];

    if (foundOrder.orderID != 0) {
      final itemDeliveredList = foundOrder.itemsDelivered;
      int itemIndex = itemDeliveredList!
          .indexWhere((element) => element.itemName == itemName);
      Item item = itemDeliveredList[itemIndex];
      item.quantitySalesDelivered =
          item.quantitySalesDelivered! - quantityReturned;
      item.quantitySalesReturned =
          item.quantitySalesReturned! + quantityReturned;
      itemDeliveredList[itemIndex] = item;
      foundOrder.itemsDelivered = itemDeliveredList;

      if (foundOrder.itemsReturned == null) {
        List<Item> itemsReturnedList = [itemReturned];
        foundOrder.itemsReturned = itemsReturnedList;
      } else {
        List<Item> itemsReturnedList = foundOrder.itemsReturned!;
        try {
          int itemIndex = itemsReturnedList
              .indexWhere((element) => element.itemName == itemName);
          Item? itemReturned = itemsReturnedList[itemIndex];
          itemReturned.quantitySalesReturned =
              itemReturned.quantitySalesReturned! + quantityReturned;
          itemsReturnedList[itemIndex] = itemReturned;
          foundOrder.itemsReturned = itemsReturnedList;
        } catch (e) {
          itemsReturnedList.add(itemReturned);
          foundOrder.itemsReturned = itemsReturnedList;
        }
      }
    }
    _so[index] = foundOrder;
    notifyListeners();
  }
  void reset() {
    _sa.clear();
    _so.clear();
    notifyListeners();
  }
}
