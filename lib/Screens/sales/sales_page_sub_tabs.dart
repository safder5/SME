import 'package:ashwani/Models/sales_order.dart';
import 'package:ashwani/Providers/new_sales_order_provider.dart';
import 'package:ashwani/Screens/sales/edit_sales_order/increase_details_item_quantity.dart';
import 'package:ashwani/Screens/sales/edit_sales_order/reduce_item_quantity.dart';
import 'package:ashwani/constantWidgets/boxes.dart';
import 'package:ashwani/constants.dart';
import 'package:ashwani/Models/iq_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SOPDetails extends StatefulWidget {
  const SOPDetails({super.key, required this.orderId});

  final int orderId;

  @override
  State<SOPDetails> createState() => _SOPDetailsState();
}

class _SOPDetailsState extends State<SOPDetails> {
  bool allDelivered = false;
  int leftquantities = 0;

  checkIfAllDelivered() {
    final prov = Provider.of<NSOrderProvider>(context, listen: false);
    SalesOrderModel som =
        prov.som.firstWhere((element) => element.orderID == widget.orderId);
    List<Item> items = som.items??[];
    if (items.isNotEmpty) {
      for (int i = 0; i < items.length; i++) {
        Item it = items[i];
        leftquantities += it.quantitySales!;
      }
      if (leftquantities == 0) {
        setState(() {
          allDelivered = true;
        });
      }
    }
  }

  int checkPrevItemDeliveredDatainProvider(String itemName) {
    int qt = 0;
    final prov = Provider.of<NSOrderProvider>(context, listen: false);
    int orderIndex =
        prov.som.indexWhere((element) => element.orderID == widget.orderId);
    final order = prov.som[orderIndex];
    final itemsDel = order.itemsDelivered ?? <Item>[];
    if (itemsDel.isEmpty) {
      qt = 0;
    } else {
      try {
        int item =
            itemsDel.indexWhere((element) => element.itemName == itemName);
        final it = itemsDel[item];
        final q = it.quantitySalesDelivered ?? 0;
        qt = q;
      } catch (e) {
        qt = 0;
        print('error$e');
      }
    }
    return qt;
  }

  @override
  void initState() {
    super.initState();
    checkIfAllDelivered();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NSOrderProvider>(builder: (_, ip, __) {
      SalesOrderModel som =
          ip.som.firstWhere((element) => element.orderID == widget.orderId);
      List<Item> items = som.items!;
      // List<Item> itemsDelivered = som.itemsDelivered ?? [];
      if (items.isEmpty) {
        print('items are null');
        return Column(
          children: [
            const Text('empty'),
            OutlinedButton(
              onPressed: () async{
// delete sales order
                await ip.deleteSalesOrderFB(widget.orderId);
                ip.deleteSO(widget.orderId);
              },
              style: OutlinedButton.styleFrom(
                // elevation: 10,
                surfaceTintColor: gn,
                backgroundColor: Colors.green.withOpacity(0.25),
              ),
              child: Text(
                'Delete Sales Order',
                style: TextStyle(color: gn),
              ),
            )
          ],
        );
      }
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Status:',
                      style: TextStyle(color: b.withOpacity(0.6)),
                    ),
                    const Spacer(),
                    Text(
                      allDelivered ? 'All Items Shipped' : 'To be shipped',
                      style: TextStyle(color: dg),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Left Quantity:',
                      style: TextStyle(color: b.withOpacity(0.6)),
                    ),
                    const Spacer(),
                    Text(
                      '$leftquantities box',
                      style: TextStyle(color: dg),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              Divider(
                height: 0,
                color: b32,
                thickness: 0.2,
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int qty = checkPrevItemDeliveredDatainProvider(
                        items[index].itemName);
                    int toship = (items[index].originalQuantity! - qty);
                    return GestureDetector(
                      onLongPress: () {
                        // Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          elevation: 10,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          content: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Edit Quantity for ${items[index].itemName}?',
                                    style: TextStyle(color: b),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  OutlinedButton(
                                    onPressed: () async {
                                      // increase quantity
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      await Future.delayed(
                                          const Duration(milliseconds: 500));
                                      if (!context.mounted) return;
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  IncreaseDetailsItemQuantity(
                                                      itemName:
                                                          items[index].itemName,
                                                      orderId:
                                                          widget.orderId)));
                                      // _showDialogIncreaseQuantity(
                                      //     context,
                                      //     items[index].itemName,
                                      //     widget.orderId);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      // elevation: 10,
                                      surfaceTintColor: gn,
                                      backgroundColor:
                                          Colors.green.withOpacity(0.25),
                                    ),
                                    child: Text(
                                      'Increase Quantity',
                                      style: TextStyle(color: gn),
                                    ),
                                  ),
                                  toship == 0
                                      ? SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: Text(
                                            'Cannot Reduce Quantity',
                                            style: TextStyle(color: b),
                                          ))
                                      : OutlinedButton(
                                          onPressed: () async {
                                            // limit to change is toship
                                            // item cannot be removed
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                            await Future.delayed(const Duration(
                                                milliseconds: 500));
                                            if (!context.mounted) return;
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ReduceItemQuantity(
                                                            itemName:
                                                                items[index]
                                                                    .itemName,
                                                            orderId:
                                                                widget.orderId,
                                                            limit: toship)));
                                          },
                                          style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.red.withOpacity(0.25)),
                                          child: Text(
                                            'Reduce Quantity',
                                            style: TextStyle(color: r),
                                          ),
                                        )
                                ],
                              ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceEvenly,
                              //   children: [
                              //     toship == items[index].originalQuantity
                              //         ? OutlinedButton(
                              //             onPressed: () async {
                              //               // limit is toship
                              //               // item can be removed
                              //               ScaffoldMessenger.of(context)
                              //                   .hideCurrentSnackBar();
                              //               await Future.delayed(const Duration(
                              //                   milliseconds: 500));
                              //               if (!context.mounted) return;
                              //               _showDialogReduceQtyAndALsoRemoveItemEntirely(
                              //                   context,
                              //                   items[index].itemName,
                              //                   widget.orderId);
                              //               // Navigator.push(
                              //               //     context,
                              //               //     MaterialPageRoute(
                              //               //         builder: (context) =>
                              //               //             ReduceItemQuantity(
                              //               //                 itemName:
                              //               //                     items[index]
                              //               //                         .itemName,
                              //               //                 orderId:
                              //               //                     widget.orderId,
                              //               //                 limit: toship)));
                              //             },
                              //             style: OutlinedButton.styleFrom(
                              //                 backgroundColor:
                              //                     Colors.red.withOpacity(0.25)),
                              //             child: Text(
                              //               'Remove Item',
                              //               style: TextStyle(color: r),
                              //             ),
                              //           )
                              //         : Container(),
                                  
                              //   ],
                              // )
                            ],
                          ),
                        ));
                      },
                      child: SOPDetailsItemTile(
                        name: items[index].itemName,
                        quantity:
                            (items[index].originalQuantity! - qty).toString(),
                        index: index,
                        original: items[index].originalQuantity ?? 0,
                      ),
                    );
                  },
                  itemCount: items.length,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class SOPShipped extends StatefulWidget {
  const SOPShipped({super.key, required this.orderId});
  final int orderId;

  @override
  State<SOPShipped> createState() => _SOPShippedState();
}

class _SOPShippedState extends State<SOPShipped> {
  bool allDelivered = false;
  int leftquantities = 0;
  int totalquantities = 0;
  checkIfAllDelivered() {
    final prov = Provider.of<NSOrderProvider>(context, listen: false);
    SalesOrderModel som =
        prov.som.firstWhere((element) => element.orderID == widget.orderId);
    List<Item> items = som.items!;
    if (items.isNotEmpty) {
      for (int i = 0; i < items.length; i++) {
        Item it = items[i];
        totalquantities += it.originalQuantity!;
        leftquantities += it.quantitySales!;
      }
      if (leftquantities == 0) {
        setState(() {
          allDelivered = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfAllDelivered();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NSOrderProvider>(builder: (_, ipd, __) {
      SalesOrderModel som =
          ipd.som.firstWhere((element) => element.orderID == widget.orderId);
      List<Item> itemsDelivered = som.itemsDelivered ?? [];
      return Container(
        height: (MediaQuery.of(context).size.height * 0.66) - 110,
        color: w,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Quantity:',
                      style: TextStyle(
                          color: b.withOpacity(0.5),
                          fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '$totalquantities box',
                      style: TextStyle(
                          color: b.withOpacity(0.5),
                          fontWeight: FontWeight.w300),
                    ),
                    const Spacer(),
                    Text(
                      '$leftquantities box left',
                      style: TextStyle(color: b, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                color: b32,
                thickness: 0.2,
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return SOPShippedItemsTile(
                        quantity: itemsDelivered[index]
                            .quantitySalesDelivered
                            .toString(),
                        itemName: itemsDelivered[index].itemName,
                        quantityReturned:
                            itemsDelivered[index].quantitySalesReturned ?? 0,
                        index: index);
                  },
                  itemCount: itemsDelivered.length,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class SOPReturns extends StatefulWidget {
  const SOPReturns({super.key, required this.orderId});
  final int orderId;

  @override
  State<SOPReturns> createState() => _SOPReturnsState();
}

class _SOPReturnsState extends State<SOPReturns> {
  @override
  Widget build(BuildContext context) {
    // final itemsReturned = widget.itemsReturned ?? [];
    // final reversedList = itemsReturned.reversed.toList();
    return Consumer<NSOrderProvider>(builder: (_, ipr, __) {
      SalesOrderModel som =
          ipr.som.firstWhere((element) => element.orderID == widget.orderId);
      List<Item> itemsReturned = som.itemsReturned ?? [];
      return Container(
        height: (MediaQuery.of(context).size.height * 0.66) - 110,
        color: w,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
          child: Column(
            children: [
              Divider(
                height: 0,
                color: b32,
                thickness: 0.2,
              ),
              itemsReturned.isEmpty
                  ? Container()
                  : Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return SOReturnsItemTile(
                            quantity: itemsReturned[index]
                                .quantitySalesReturned
                                .toString(),
                            itemName: itemsReturned[index].itemName,
                            index: index,
                          );
                        },
                        itemCount: itemsReturned.length,
                      ),
                    ),
            ],
          ),
        ),
      );
    });
  }
}

// void _showDialogIncreaseQuantity(
//     BuildContext context, String itemName, int orderId) {
//   showDialog(
//       context: context,
//       builder: (context) {
//         TextEditingController quantityController = TextEditingController();
//         return AlertDialog(
//           surfaceTintColor: w,
//           backgroundColor: w,
//           title: Text('Increase Quantity of $itemName by value?'),
//           content: TextField(
//             keyboardType: TextInputType.number,
//             controller: quantityController,
//             decoration: getInputDecoration(
//                 hint: 'Increase quantity by ', errorColor: r),
//           ),
//           actions: [
//             Row(
//               children: [
//                 TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Text(
//                       'Cancel',
//                       style: TextStyle(color: blue),
//                     )),
//                 const Spacer(),
//                 TextButton(
//                     onPressed: () async {
//                       int q = int.parse(quantityController.text);
//                       final prov =
//                           Provider.of<NSOrderProvider>(context, listen: false);
//                       prov.updateitemDetailsquantityinProvider(
//                           orderId, itemName, q);
//                       prov.updateitemDetailsquantityinFireBase(
//                           orderId, itemName, q);
//                       //update itemdetails in salesorder in providers
//                       // update the same in firebase

//                       Navigator.of(context).pop();
//                     },
//                     child: Text(
//                       'Save',
//                       style: TextStyle(color: blue),
//                     )),
//               ],
//             )
//           ],
//         );
//       });
// }

// void _showDialogReduceQtyAndALsoRemoveItemEntirely(
//   BuildContext context,
//   String itemName,
//   int orderId,
// ) {
//   showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           surfaceTintColor: w,
//           backgroundColor: w,
//           title: Text(
//               'Are you sure you want delete $itemName from this Sales Order?'),
//           // content:
//           actions: [
//             Row(
//               children: [
//                 TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Text(
//                       'Cancel',
//                       style: TextStyle(color: r),
//                     )),
//                 const Spacer(),
//                 // another button of remove item entirely
//                 TextButton(
//                     onPressed: () async {
//                       final prov =
//                           Provider.of<NSOrderProvider>(context, listen: false);
//                       await prov.removeSOItemEntirelyFB(orderId, itemName);
//                       prov.removeSalesItementirely(orderId, itemName);
//                       if (!context.mounted) return;
//                       Navigator.of(context).pop();
//                     },
//                     child: Text(
//                       'Yes',
//                       style: TextStyle(color: blue),
//                     )),
//               ],
//             )
//           ],
//         );
//       });
// }

// void _showDialogReduceQuantityOnly(
//     BuildContext context, String itemName, int orderId, int limit) {
//   showDialog(
//       context: context,
//       builder: (context) {
//         TextEditingController quantityController = TextEditingController();
//         return AlertDialog(
//           surfaceTintColor: w,
//           backgroundColor: w,
//           title: Text('Increase Quantity of $itemName by value?'),
//           content: TextField(
//             keyboardType: TextInputType.number,
//             controller: quantityController,
//             decoration: getInputDecoration(
//                 hint: 'Increase quantity by ', errorColor: r),
//           ),
//           actions: [
//             Row(
//               children: [
//                 TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Text(
//                       'Cancel',
//                       style: TextStyle(color: blue),
//                     )),
//                 const Spacer(),
//                 TextButton(
//                     onPressed: () async {
//                       // final now = DateTime.now();
//                       // //save quantity and update
//                       // final int q =
//                       //     int.parse(quantityController.text) + (sih ?? 0);
//                       // int tQ = int.parse(quantityController.text);
//                       // await prov.stockAdjustinFB(q, itemName, now, tQ);
//                       // prov.stockAdjustinProvider(q, itemName, now, tQ);
//                       Navigator.of(context).pop();
//                     },
//                     child: Text(
//                       'Save',
//                       style: TextStyle(color: blue),
//                     )),
//               ],
//             )
//           ],
//         );
//       });
// }
