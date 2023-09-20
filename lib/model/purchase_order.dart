import 'package:ashwani/model/iq_list.dart';

class PurchaseOrderModel {
  final int? orderID;
  final String? vendorName;
  final String? purchaseDate;
  final String? deliveryDate;
  final String? notes;
  final String? tandc;
  final String? paymentTerms;
  final String? deliveryMethod;
  final String? status;
  List<Item>? items;

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
  });
}
