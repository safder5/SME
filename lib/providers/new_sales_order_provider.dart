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

  SalesOrderModel _lastUpdatedSalesOrder = SalesOrderModel(
      orderID: 0,
      customerName: 'customerName',
      orderDate: 'orderDate',
      shipmentDate: 'shipmentDate',
      paymentMethods: 'paymentMethods',
      notes: 'notes',
      tandC: 'tandC',
      status: 'status');

  SalesOrderModel get lastUpdatedSalesOrder => _lastUpdatedSalesOrder;
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
            );
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
      int orderId, String itemName, int quantitydelivered) {
    SalesOrderModel? foundOrder =
        _so.firstWhere((order) => order.orderID == orderId);
    if (foundOrder.orderID != 0) {
      final itemsList = foundOrder.items;
      Item? item =
          itemsList!.firstWhere((element) => element.itemName == itemName);
      item.quantitySales = item.quantitySales! - quantitydelivered;

      final itemDeliveredList = foundOrder.itemsDelivered;
      Item? itemDelivered = itemDeliveredList!
          .firstWhere((element) => element.itemName == itemName);
      itemDelivered.quantitySalesDelivered =
          itemDelivered.quantitySalesDelivered! + quantitydelivered;
      _lastUpdatedSalesOrder = foundOrder;
      _sa.clear();
    }
    notifyListeners();
  }

  void updateSalesItemsReturnedProviders(
      int orderId, String itemName, int quantityReturned) {
    SalesOrderModel? foundOrder =
        _so.firstWhere((order) => order.orderID == orderId);
    if (foundOrder.orderID != 0) {
      final itemReturnedList = foundOrder.itemsReturned;
      Item? itemReturned = itemReturnedList!
          .firstWhere((element) => element.itemName == itemName);
      itemReturned.quantitySalesReturned =
          itemReturned.quantitySalesReturned! + quantityReturned;

      final itemDeliveredList = foundOrder.itemsDelivered;
      Item? itemDelivered = itemDeliveredList!
          .firstWhere((element) => element.itemName == itemName);
      itemDelivered.quantitySalesDelivered =
          itemDelivered.quantitySalesDelivered! - quantityReturned;
      itemDelivered.quantitySalesReturned =
          itemDelivered.quantitySalesReturned! - quantityReturned;
      _lastUpdatedSalesOrder = foundOrder;
      _sa.clear();
    }
    notifyListeners();
  }

  void addSalesReturnInProvider(
    int orderId,
    String itemName,
    Item itemReturned,
  ) {
    try {
      SalesOrderModel foundOrder =
          _so.firstWhere((order) => order.orderID == orderId);
      if (foundOrder.orderID != 0) {
        final itemsReturned = foundOrder.itemsReturned ?? [];
        itemsReturned.add(itemReturned);
        foundOrder.itemsReturned = itemsReturned;
        _lastUpdatedSalesOrder = foundOrder;
        _sa.clear();
      }
      notifyListeners();
    } catch (e) {
      print('error addSalesReturnInProvider $e');
    }
  }

  void addSalesDeliveredInProvider(
    int orderId,
    String itemName,
    Item itemDelivered,
  ) {
    try {
      SalesOrderModel foundOrder =
          _so.firstWhere((order) => order.orderID == orderId);
      if (foundOrder.orderID != 0) {
        final itemsDelivered = foundOrder.itemsDelivered ?? [];
        itemsDelivered.add(itemDelivered);
        foundOrder.itemsDelivered = itemsDelivered;
        _lastUpdatedSalesOrder = foundOrder;
        _sa.clear();
      } else {
        print('orderId me gadbad hai');
      }
      notifyListeners();
    } catch (e) {
      print('error in addSalesDeliveredInProvider $e');
    }
  }

  // make a function to open close status of sales order
}
