import 'package:ashwani/src/Models/iq_list.dart';

class PurchaseOrderModel {
  final int orderID;
  final String? vendorName;
  final String? purchaseDate;
  final String? deliveryDate;
  final String? notes;
  final String? tandc;
  final String? paymentTerms;
  final String? deliveryMethod;
  final String? status;
  List<Item>? items;
    List<ItemTrackingPurchaseOrder>? tracks;
  List<ItemTrackingPurchaseOrder>? itemsRecieved;
  List<ItemTrackingPurchaseOrder>? itemsReturned;

  PurchaseOrderModel({
    required this.orderID,
    required this.vendorName,
    required this.purchaseDate,
    required this.deliveryDate,
    required this.paymentTerms,
    required this.deliveryMethod,
    required this.notes,
    required this.tandc,
    required this.status,
    this.items,
    this.itemsRecieved,
    this.itemsReturned,
    this.tracks,
  });

  // int calculateQuantityToReceive() {
  //   if (items == null || itemsRecieved == null) {
  //     return 0;
  //   }

  //   int totalOrdered = items!.fold<int>(0,
  //       (previousValue, item) =>  (item.originalQuantity ?? 0));

  //   int totalReceived = itemsRecieved!.fold<int>(
  //       0,
  //       (previousValue, receivedItem) =>
  //             (receivedItem.quantityRecieved ?? 0));

  //   return totalOrdered - totalReceived;
  // }
}
