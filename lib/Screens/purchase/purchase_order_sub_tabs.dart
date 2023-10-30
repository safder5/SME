import 'package:ashwani/Models/purchase_order.dart';
import 'package:ashwani/Providers/new_purchase_order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/iq_list.dart';
import '../../constantWidgets/boxes.dart';
import '../../constants.dart';

class POPDetails extends StatefulWidget {
  const POPDetails({super.key, required this.orderId});

  final int orderId;
  @override
  State<POPDetails> createState() => _POPDetailsState();
}

class _POPDetailsState extends State<POPDetails> {
  // bool allRecieved = false;
  // int qrecieved = 0;

  // checkAllRecieved() {
  //    if (widget.items.isNotEmpty) {
  //     for (int i = 0; i < widget.items.length; i++) {
  //       Item it = widget.items[i];
  //       qrecieved += it.itemQuantity!;
  //     }
  //     if(qrecieved == 0){
  //       setState(() {
  //         allRecieved = true;
  //       });
  //     }
  //   }
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NPOrderProvider>(builder: (_, op, __) {
      PurchaseOrderModel po =
          op.po.firstWhere((element) => element.orderID == widget.orderId);
      List<Item> items = po.items!;
      print(widget.orderId);
      print(items.length);
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
                      textScaleFactor: 1.2,
                      style: TextStyle(color: b.withOpacity(0.6)),
                    ),
                    const Spacer(),
                    // Text(
                    //   allRecieved? 'All Recieved':'Order Placed',
                    //   textScaleFactor: 1.2,
                    //   style: TextStyle(color: dg),
                    // ),
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
                    return SOPDetailsItemTile(
                      name: items[index].itemName!,
                      quantity: items[index].itemQuantity.toString(),
                      index: index,
                      original: items[index].originalQuantity ?? 0,
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final itemsRecieved = widget.itemsRecieved ?? [];
    // final reversedItems = itemsRecieved.reversed.toList();

    return Consumer<NPOrderProvider>(builder: (_, opr, __) {
      PurchaseOrderModel po =
          opr.po.firstWhere((element) => element.orderID == widget.orderId);
      List<ItemTrackingPurchaseOrder> items =
          po.itemsRecieved?? [];
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
    return Consumer<NPOrderProvider>(
      builder: (_,pr,__) {
        PurchaseOrderModel po =
          pr.po.firstWhere((element) => element.orderID == widget.orderId);
      List<ItemTrackingPurchaseOrder> items =
          po.itemsRecieved?? [];
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
      }
    );
  }
}
