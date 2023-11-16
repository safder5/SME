import 'package:ashwani/Models/sales_order.dart';
import 'package:ashwani/Providers/new_sales_order_provider.dart';
import 'package:ashwani/constantWidgets/boxes.dart';
import 'package:ashwani/constants.dart';
import 'package:ashwani/Models/iq_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Services/helper.dart';

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
    List<Item> items = som.items!;
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
      int item = itemsDel.indexWhere((element) => element.itemName == itemName);
      final it = itemsDel[item];
      final q = it.quantitySalesDelivered ?? 0;
      qt = q;
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
      List<Item> itemsDelivered = som.itemsDelivered ?? [];
      if (items.isEmpty) {
        print('items are null');
        return const Text('empty');
      }
      return Container(
        height: (MediaQuery.of(context).size.height * 0.66) - 70,
        color: w,
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
                      textScaleFactor: 1,
                      style: TextStyle(color: b.withOpacity(0.6)),
                    ),
                    const Spacer(),
                    Text(
                      allDelivered ? 'All Items Shipped' : 'To be shipped',
                      textScaleFactor: 1,
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
                      textScaleFactor: 1,
                      style: TextStyle(color: b.withOpacity(0.6)),
                    ),
                    const Spacer(),
                    Text(
                      '$leftquantities box',
                      textScaleFactor: 1,
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
                                    onPressed: () {
                                      // increase quantity
                                      _showDialogIncreaseQuantity(
                                          context,
                                          items[index].itemName,
                                          widget.orderId);
                                    },
                                    style: OutlinedButton.styleFrom(
                                        surfaceTintColor: gn,
                                        backgroundColor:
                                            Colors.green.withOpacity(0.25)),
                                    child: Text(
                                      'Increase Quantity',
                                      style: TextStyle(color: gn),
                                    ),
                                  ),
                                  toship == items[index].originalQuantity
                                      ? OutlinedButton(
                                          onPressed: () {
                                            // limit is toship
                                            // item can be removed
                                            _showDialogReduceQtyAndALsoRemoveItemEntirely(
                                                context,
                                                items[index].itemName,
                                                widget.orderId);
                                          },
                                          style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.red.withOpacity(0.25)),
                                          child: Text(
                                            'Remove Quantity',
                                            style: TextStyle(color: r),
                                          ),
                                        )
                                      : toship == 0
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
                                              onPressed: () {
                                                // limit to change is toship
                                                // item cannot be removed
                                                _showDialogReduceQuantityOnly(
                                                    context,
                                                    items[index].itemName,
                                                    widget.orderId,
                                                    toship);
                                              },
                                              style: OutlinedButton.styleFrom(
                                                  backgroundColor: Colors.red
                                                      .withOpacity(0.25)),
                                              child: Text(
                                                'Remove Quantity',
                                                style: TextStyle(color: r),
                                              ),
                                            )
                                ],
                              ),
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
                      textScaleFactor: 1,
                      style: TextStyle(
                          color: b.withOpacity(0.5),
                          fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '$totalquantities box',
                      textScaleFactor: 1,
                      style: TextStyle(
                          color: b.withOpacity(0.5),
                          fontWeight: FontWeight.w300),
                    ),
                    const Spacer(),
                    Text(
                      '$leftquantities box left',
                      textScaleFactor: 1,
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

void _showDialogIncreaseQuantity(
    BuildContext context, String itemName, int orderId) {
  showDialog(
      context: context,
      builder: (context) {
        TextEditingController quantityController = TextEditingController();
        return AlertDialog(
          surfaceTintColor: w,
          backgroundColor: w,
          title: Text('Increase Quantity of $itemName by value?'),
          content: TextField(
            keyboardType: TextInputType.number,
            controller: quantityController,
            decoration: getInputDecoration(
                hint: 'Increase quantity by ', errorColor: r),
          ),
          actions: [
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: blue),
                    )),
                const Spacer(),
                TextButton(
                    onPressed: () async {
                      int q = int.parse(quantityController.text);
                      final prov =
                          Provider.of<NSOrderProvider>(context, listen: false);
                      prov.updateitemDetailsquantityinProvider(
                          orderId, itemName, q);
                      prov.updateitemDetailsquantityinFireBase(
                          orderId, itemName, q);
                      //update itemdetails in salesorder in providers
                      // update the same in firebase

                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(color: blue),
                    )),
              ],
            )
          ],
        );
      });
}

void _showDialogReduceQtyAndALsoRemoveItemEntirely(
  BuildContext context,
  String itemName,
  int orderId,
) {
  showDialog(
      context: context,
      builder: (context) {
        TextEditingController quantityController = TextEditingController();
        return AlertDialog(
          surfaceTintColor: w,
          backgroundColor: w,
          title: Text('Reduce Quantity of $itemName by value?'),
          content: TextField(
            keyboardType: TextInputType.number,
            controller: quantityController,
            decoration: getInputDecoration(
                hint: 'Increase quantity by ', errorColor: r),
          ),
          actions: [
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: blue),
                    )),
                const Spacer(),
                // another button of remove item entirely
                TextButton(
                    onPressed: () async {
                      // final now = DateTime.now();
                      // //save quantity and update
                      // final int q =
                      //     int.parse(quantityController.text) + (sih ?? 0);
                      // int tQ = int.parse(quantityController.text);
                      // await prov.stockAdjustinFB(q, itemName, now, tQ);
                      // prov.stockAdjustinProvider(q, itemName, now, tQ);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(color: blue),
                    )),
              ],
            )
          ],
        );
      });
}

void _showDialogReduceQuantityOnly(
    BuildContext context, String itemName, int orderId, int limit) {
  showDialog(
      context: context,
      builder: (context) {
        TextEditingController quantityController = TextEditingController();
        return AlertDialog(
          surfaceTintColor: w,
          backgroundColor: w,
          title: Text('Increase Quantity of $itemName by value?'),
          content: TextField(
            keyboardType: TextInputType.number,
            controller: quantityController,
            decoration: getInputDecoration(
                hint: 'Increase quantity by ', errorColor: r),
          ),
          actions: [
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: blue),
                    )),
                const Spacer(),
                TextButton(
                    onPressed: () async {
                      // final now = DateTime.now();
                      // //save quantity and update
                      // final int q =
                      //     int.parse(quantityController.text) + (sih ?? 0);
                      // int tQ = int.parse(quantityController.text);
                      // await prov.stockAdjustinFB(q, itemName, now, tQ);
                      // prov.stockAdjustinProvider(q, itemName, now, tQ);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(color: blue),
                    )),
              ],
            )
          ],
        );
      });
}
