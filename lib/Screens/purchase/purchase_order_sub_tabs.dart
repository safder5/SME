import 'package:ashwani/Models/purchase_order.dart';
import 'package:ashwani/Providers/new_purchase_order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/iq_list.dart';
import '../../Services/helper.dart';
import '../../constantWidgets/boxes.dart';
import '../../constants.dart';

class POPDetails extends StatefulWidget {
  const POPDetails({super.key, required this.orderId});

  final int orderId;
  @override
  State<POPDetails> createState() => _POPDetailsState();
}

class _POPDetailsState extends State<POPDetails> {
  bool allRecieved = false;
  int qrecieved = 0;

  checkAllRecieved() {
    final prov = Provider.of<NPOrderProvider>(context, listen: false);
    PurchaseOrderModel po =
        prov.po.firstWhere((element) => element.orderID == widget.orderId);
    List<Item> items = po.items ?? [];
    if (items.isNotEmpty) {
      for (int i = 0; i < items.length; i++) {
        Item it = items[i];
        qrecieved += it.quantityPurchase!;
      }
      if (qrecieved == 0) {
        setState(() {
          allRecieved = true;
        });
      }
    }
  }

  int checkPrevItemRecievedDatainProvider(String itemName) {
    int qt = 0;
    final prov = Provider.of<NPOrderProvider>(context, listen: false);
    int orderIndex =
        prov.po.indexWhere((element) => element.orderID == widget.orderId);
    final order = prov.po[orderIndex];
    final itemsDel = order.itemsRecieved ?? <ItemTrackingPurchaseOrder>[];
    if (itemsDel.isEmpty) {
      qt = 0;
    } else {
      try {
        int item =
            itemsDel.indexWhere((element) => element.itemName == itemName);
        final it = itemsDel[item];
        final q = it.quantityRecieved;
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
    // TODO: implement initState
    super.initState();
    checkAllRecieved();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NPOrderProvider>(builder: (_, op, __) {
      PurchaseOrderModel po =
          op.po.firstWhere((element) => element.orderID == widget.orderId);
      List<Item> items = po.items ?? [];
      // List<ItemTrackingPurchaseOrder> itemsRecieved = po.itemsRecieved ?? [];
      // print(widget.orderId);
      // print(items.length);
      if (items.isEmpty) {
        print('items are null');
        return const Text('empty');
      }
      return Container(
        height: (MediaQuery.of(context).size.height * 0.65) - 70,
        color: w,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Status',
                      textScaleFactor: 1,
                      style: TextStyle(color: b.withOpacity(0.6)),
                    ),
                    const Spacer(),
                    Text(
                      allRecieved ? 'All Recieved' : 'Order Placed',
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
                    int quantity = checkPrevItemRecievedDatainProvider(
                        items[index].itemName);
                    int toRecieve = items[index].originalQuantity! - quantity;
                    return GestureDetector(
                      onLongPress: () {
                        //  Navigator.of(context).pop();
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
                                  toRecieve == items[index].originalQuantity
                                      ? OutlinedButton(
                                          onPressed: () {
                                            // limit is toRecieve
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
                                      : toRecieve == 0
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
                                                    toRecieve);
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
                      child: PoDetailsItemTile(
                        name: items[index].itemName,
                        quantity: (items[index].originalQuantity! - quantity)
                            .toString(),
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

class POPRecieved extends StatefulWidget {
  const POPRecieved({super.key, required this.orderId});
  final int orderId;

  @override
  State<POPRecieved> createState() => _POPRecievedState();
}

class _POPRecievedState extends State<POPRecieved> {
  bool allRecieved = false;
  int qrecieved = 0;

  checkAllRecieved() {
    final prov = Provider.of<NPOrderProvider>(context, listen: false);
    PurchaseOrderModel po =
        prov.po.firstWhere((element) => element.orderID == widget.orderId);
    List<ItemTrackingPurchaseOrder> items = po.itemsRecieved ?? [];
    if (items.isNotEmpty) {
      for (int i = 0; i < items.length; i++) {
        ItemTrackingPurchaseOrder it = items[i];
        qrecieved += it.quantityRecieved;
      }
      if (qrecieved == 0) {
        setState(() {
          allRecieved = true;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAllRecieved();
  }

  @override
  Widget build(BuildContext context) {
    // final itemsRecieved = widget.itemsRecieved ?? [];
    // final reversedItems = itemsRecieved.reversed.toList();

    return Consumer<NPOrderProvider>(builder: (_, opr, __) {
      PurchaseOrderModel po =
          opr.po.firstWhere((element) => element.orderID == widget.orderId);
      List<ItemTrackingPurchaseOrder> items = po.itemsRecieved ?? [];
      print(widget.orderId);
      print(items.length);
      if (items.isEmpty) {
        print('items are null');
        return const Text('empty');
      }
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
                      'Total recieved:',
                      textScaleFactor: 1,
                      style: TextStyle(
                          color: b.withOpacity(0.5),
                          fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '$qrecieved box ',
                      textScaleFactor: 1,
                      style: TextStyle(
                          color: b.withOpacity(0.5),
                          fontWeight: FontWeight.w300),
                    ),
                    const Spacer(),
                    //  Text(
                    //   '$totalquantities box',
                    //   textScaleFactor: 1,
                    //   style: TextStyle(
                    //       color: b.withOpacity(0.5),
                    //       fontWeight: FontWeight.w300),
                    // ),
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
                    return PORecievedItemTile(
                        quantity: items[index].quantityRecieved.toString(),
                        itemName: items[index].itemName,
                        quantityReturned: items[index].quantityReturned,
                        index: index);
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

class POPReturns extends StatefulWidget {
  const POPReturns({super.key, required this.orderId});
  final int orderId;
  @override
  State<POPReturns> createState() => _POPReturnsState();
}

class _POPReturnsState extends State<POPReturns> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final itemsReturned = widget.itemsReturned ?? [];
    // final itemsReversed = itemsReturned.reversed.toList();
    return Consumer<NPOrderProvider>(builder: (_, pr, __) {
      PurchaseOrderModel po =
          pr.po.firstWhere((element) => element.orderID == widget.orderId);
      List<ItemTrackingPurchaseOrder> items = po.itemsRecieved ?? [];
      print(widget.orderId);
      print(items.length);
      if (items.isEmpty) {
        print('items are null');
        return const Text('empty');
      }
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
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return POReturnsTile(
                        itemName: items[index].itemName,
                        quantityReturned: items[index].quantityReturned,
                        index: index);
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
