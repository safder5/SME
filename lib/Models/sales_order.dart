import 'package:ashwani/Models/iq_list.dart';

class SalesOrderModel {
  final int? orderID;
  final String? customerName;
  final String? orderDate;
  final String? shipmentDate;
  final String? paymentMethods;
  final String? notes;
  final String? tandC;
  final String? status;
  List<Item>? items;

  SalesOrderModel({
    required this.orderID,
    required this.customerName,
    required this.orderDate,
    required this.shipmentDate,
    required this.paymentMethods,
    required this.notes,
    required this.tandC,
    required this.status,
    this.items,
  });
}

// (String cN,String oID,String oD,String sD,String pM,String n,String tc,List<String> items,List<int> quantity)
// customerName = cN;
//     orderID = oID;
//     oderDate = oD;
//     shipmentDate = sD;
//     paymentMethods = pM;
//     notes = n;
//     tandC = tc;
//     itemsList = items;
//     quantityList = quantity;


// SalesOrderModel.fromMap(Map<dynamic, dynamic> res)
//       : orderID = res['orderID'],
//         customerName = res['customerName'],
//         shipmentDate = res['shipmentDate'],
//         orderDate = res['orderDate'],
//         paymentMethods = res['paymentMethods'],
//         notes = res['notes'],
//         tandC = res['tandC'];

//   Map<String, Object?> toMap() {
//     return {
//       'orderID': orderID,
//       'customerName': customerName ?? '',
//       'shipmentDate': shipmentDate ?? '',
//       'orderDate': orderDate ?? '',
//       'paymentMethods': paymentMethods ?? '',
//       'notes': notes ?? '',
//       'tandC': tandC ?? '',
//     };
//   }