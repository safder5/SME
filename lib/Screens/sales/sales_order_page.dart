import 'package:ashwani/Screens/sales/sales_order_return_transaction.dart';
import 'package:ashwani/Screens/sales/sales_order_transaction.dart';
import 'package:ashwani/Screens/sales/sales_page_helping_widgets.dart';
import 'package:ashwani/constants.dart';
import 'package:ashwani/Models/sales_order.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';

class SalesOrderPage extends StatefulWidget {
  const SalesOrderPage({super.key, required this.salesorder});
  final SalesOrderModel salesorder;

  @override
  State<SalesOrderPage> createState() => _SalesOrderPageState();
}

class _SalesOrderPageState extends State<SalesOrderPage> {
  List<bool> isSelected = [true, false, false];
  List<String> toggleButtons = [('Details'), ('Shipped'), ('Returns')];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: w,
      floatingActionButton: Visibility(
        visible: isSelected[0] ? false : true,
        child: FloatingActionButton(
          onPressed: () {
            if (isSelected[1]) {
              showModalBottomSheet<dynamic>(
                  backgroundColor: t,
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return SalesOrderTransactionsShipped(
                      items: widget.salesorder.items,
                      orderId: widget.salesorder.orderID!,
                    );
                  });
            }
            if (isSelected[2]) {
              showModalBottomSheet<dynamic>(
                  backgroundColor: t,
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return SalesOrderReturnTransactions(
                      itemsDelivered: widget.salesorder.itemsDelivered,
                      orderId: widget.salesorder.orderID!,
                    );
                  });
            }
          },
          backgroundColor: blue,
          child: Icon(
            Icons.add,
            color: w,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.34,
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
                            'Sales Order',
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
                      Row(
                        children: [
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
                                    widget.salesorder.orderID.toString(),
                                    style: TextStyle(color: w),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.salesorder.customerName!,
                                style: TextStyle(
                                    color: w,
                                    decoration: TextDecoration.underline),
                                textScaleFactor: 0.8,
                              ),
                            ],
                          ),
                          Spacer(),
                          Icon(
                            Icons.attach_file_outlined,
                            size: 36,
                            color: w,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order date : ${widget.salesorder.orderDate}',
                            style: TextStyle(color: w),
                            textScaleFactor: 0.8,
                          ),
                          Text(
                            'Delivery date : ${widget.salesorder.shipmentDate}',
                            style: TextStyle(color: w),
                            textScaleFactor: 0.8,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      GestureDetector(
                        onTap: () {
                          //marking status
                        },
                        child: Container(
                          height: 35,
                          width: 115,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: 0.7, color: w)),
                          child: Center(
                              child: Text(
                            'Mark as Shipped',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, color: w),
                            textScaleFactor: 0.8,
                          )),
                        ),
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
                              color: isSelected[i] ? blue : b.withOpacity(0.03),
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

                    // ElevatedButton(
                    //   onPressed: () {
                    //     setState(() {
                    //       for (var buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                    //         if (buttonIndex == i) {
                    //           isSelected[buttonIndex] = true;
                    //         } else {
                    //           isSelected[buttonIndex] = false;
                    //         }
                    //       }
                    //     });
                    //   },
                    //   style: ButtonStyle(
                    //     elevation: MaterialStateProperty.all(0),
                    //     backgroundColor: MaterialStateProperty.all(isSelected[i] ? blue : b.withOpacity(0.03)),
                    //      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    //       RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10.0), // Border radius of 10
                    //       ),
                    //     ),
                    //   ),
                    //   child: Text(toggleButtons[i],style: TextStyle(color: isSelected[i]? w:b,fontWeight: FontWeight.w300),textScaleFactor: 1.2,),
                    // ),
                  ],
                ),
              ],
            ),
          ),
          if (isSelected[0])
            SOPDetails(
              items: widget.salesorder.items,
            ),
          if (isSelected[1])
            SOPShipped(
              itemsDelivered: widget.salesorder.itemsDelivered,
            ),
          if (isSelected[2])
            SOPReturns(
              itemsReturned: widget.salesorder.itemsReturned,
            ),
          // Container(
          //   height: MediaQuery.of(context).size.height*0.6,
          //   width: double.maxFinite,
          //   decoration: BoxDecoration(color: w),
          // )
        ],
      ),
    );
  }
}
