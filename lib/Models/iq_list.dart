import 'package:ashwani/Models/item_tracking_model.dart';
import 'package:flutter/material.dart';

class Item {
  final String? itemName;
  int? itemQuantity;
  int? quantityPurchase;
  int? quantitySales;
  int? quantitySalesDelivered;
  int? quantitySalesReturned;
  List<ItemTrackingModel>? itemTracks;
  String? imageURL;

  Item({
    required this.itemName,
    this.itemQuantity,
    this.quantityPurchase,
    this.quantitySales,
    this.itemTracks,
    this.imageURL,
    this.quantitySalesDelivered,
    this.quantitySalesReturned,
  });
}

class ItemTrackingSalesOrder {
  String itemName;
  int quantityShipped;
  int quantityReturned;
  String? date;
  String? customer;

  ItemTrackingSalesOrder({
    required this.itemName,
    this.quantityShipped = 0,
    this.quantityReturned = 0,
    this.date,
    this.customer,
  });
}

class SalesReturnItemTracking {
  String? referenceNo;
  int orderId;
  String itemname;
  int? quantitySalesReturned;
  String? date;
  bool? toInventory;

  SalesReturnItemTracking(
      {required this.orderId,
      required this.itemname,
      this.referenceNo,
      this.date,
      this.quantitySalesReturned,
      this.toInventory});
}

class ItemTrackingPurchaseOrder {
  String itemName;
  int quantityRecieved;
  int quantityReturned;
  String? date;
  String? vendor;

  ItemTrackingPurchaseOrder({
    required this.itemName,
    this.quantityRecieved = 0,
    this.quantityReturned = 0,
    this.date,
    this.vendor,
  });
}

class PurchaseReturnItemTracking {
  String? referenceNo;
  int orderId;
  String itemname;
  int? quantity;
  String? date;
  bool? toSeller;

  PurchaseReturnItemTracking(
      {required this.orderId,
      required this.itemname,
      this.referenceNo,
      this.date,
      this.quantity,
      this.toSeller});
}
