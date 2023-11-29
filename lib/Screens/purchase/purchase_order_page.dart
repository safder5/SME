import 'package:ashwani/Models/purchase_order.dart';
import 'package:ashwani/Providers/new_purchase_order_provider.dart';
import 'package:ashwani/Screens/purchase/purchase_order_recieved_items.dart';
import 'package:ashwani/Screens/purchase/purchase_order_return_items.dart';
import 'package:ashwani/Screens/purchase/purchase_order_sub_tabs.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class PurchaseOrderPage extends StatefulWidget {
  const PurchaseOrderPage({super.key, required this.orderId});
  // final PurchaseOrderModel purchaseOrder;
  final int orderId;

  @override
  State<PurchaseOrderPage> createState() => _PurchaseOrderPageState();
}

class _PurchaseOrderPageState extends State<PurchaseOrderPage> {
  List<bool> isSelected = [true, false, false];
  List<String> toggleButtons = [('Details'), ('Recieved'), ('Returns')];
  @override
  Widget build(BuildContext context) {
    // print(widget.purchaseOrder.itemsRecieved!.length);
    return Consumer<NPOrderProvider>(builder: (_, pop, __) {
      PurchaseOrderModel purchaseOrder =
          pop.po.firstWhere((element) => element.orderID == widget.orderId);
      return Scaffold(
        backgroundColor: w,
        floatingActionButton: Visibility(
            visible: isSelected[0] ? false : true,
            child: FloatingActionButton(
              onPressed: () {
                if (isSelected[1]) {
                  // show modal sheet to add items that have been recieved
                  try {
                    showModalBottomSheet<dynamic>(
                        backgroundColor: t,
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return PurchaseOrderRecievedItems(
                              vendor: purchaseOrder.vendorName!,
                              itemsofOrder: purchaseOrder.items,
                              orderId: purchaseOrder.orderID);
                        });
                  } catch (e) {
                    print('yeh hua hai $e');
                  }
                }
                if (isSelected[2]) {
                  // show modal sheet to add items for returned order
                  // #DONOT
                  //forget the reason why it was returned
                  final k = purchaseOrder.itemsRecieved??[];
                  if (k.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: w,
                        content: Text(
                          'No Items Recieved Yet!',
                          style: TextStyle(color: blue,fontSize: 16),
                        )));
                  } else {
                    showModalBottomSheet<dynamic>(
                        backgroundColor: t,
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return PurchaseOrderReturnItems(
                            itemsRecieved: purchaseOrder.itemsRecieved,
                            orderId: purchaseOrder.orderID,
                            vendor: purchaseOrder.vendorName!,
                          );
                        });
                  }
                }
              },
              backgroundColor: blue,
              child: Icon(
                Icons.add,
                color: w,
              ),
            )),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.maxFinite,
              decoration: BoxDecoration(color: blue),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 0.0, top: 16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  LineIcons.angleLeft,
                                  color: w,
                                )),
                            const SizedBox(width: 10),
                            Text(
                              'Purchase Order',
                              style: TextStyle(
                                  color: w, fontWeight: FontWeight.w300),
                              textScaleFactor: 1.2,
                            ),
                            const Spacer(),
                            Icon(
                              Icons.edit_note_outlined,
                              color: w,
                            ),
                            const SizedBox(width: 15),
                            Icon(
                              FontAwesomeIcons.ellipsisVertical,
                              color: w,
                              size: 18,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 11,
                                  width: 11,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(1),
                                    color: w,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  purchaseOrder.orderID.toString(),
                                  style: TextStyle(color: w),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  purchaseOrder.vendorName!,
                                  style: TextStyle(
                                      color: w,
                                      decoration: TextDecoration.underline),
                                  textScaleFactor: 0.8,
                                ),
                                const Spacer(),
                                Text(
                                  purchaseOrder.status!,
                                  style: TextStyle(
                                      color: w, fontWeight: FontWeight.w500),
                                  textScaleFactor: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Purchase date : ${purchaseOrder.purchaseDate!}',
                          style: TextStyle(color: w),
                          textScaleFactor: 0.8,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // GestureDetector(
                            //   onTap: () {
                            //     //marking status
                            //   },
                            //   child: Container(
                            //     height: 35,
                            //     width: 115,
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(5),
                            //         border: Border.all(width: 0.7, color: w)),
                            //     child: Center(
                            //         child: Text(
                            //       'Mark as Recieved',
                            //       style: TextStyle(
                            //           fontWeight: FontWeight.w500, color: w),
                            //       textScaleFactor: 0.8,
                            //     )),
                            //   ),
                            // ),
                            Text(
                              'Delivery date : ${purchaseOrder.deliveryDate!}',
                              style: TextStyle(color: w),
                              textScaleFactor: 0.8,
                            ),
                          ],
                        )
                      ]),
                ),
              ),
            ),

            Container(
              // height: MediaQuery.of(context).size.height * 0.66,
              color: w,
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      for (var i = 0; i < isSelected.length; i++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              for (var buttonIndex = 0;
                                  buttonIndex < isSelected.length;
                                  buttonIndex++) {
                                if (buttonIndex == i) {
                                  isSelected[buttonIndex] = true;
                                } else {
                                  isSelected[buttonIndex] = false;
                                }
                              }
                            });
                          },
                          child: Container(
                            height: 45,
                            width: 105,
                            decoration: BoxDecoration(
                                color:
                                    isSelected[i] ? blue : b.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              toggleButtons[i],
                              style: TextStyle(
                                  color: isSelected[i] ? w : b,
                                  fontWeight: FontWeight.w300),
                              textScaleFactor: 1.2,
                            )),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
            // SizedBox(height: 20,),
            if (isSelected[0])
              POPDetails(
                orderId: widget.orderId,
              ),
            if (isSelected[1])
              POPRecieved(
                orderId: widget.orderId,
              ),
            if (isSelected[2])
              POPReturns(
                orderId: widget.orderId,
              ),
          ],
        ),
      );
    });
  }
}
