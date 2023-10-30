import 'package:ashwani/Models/sales_order.dart';
import 'package:ashwani/Providers/new_sales_order_provider.dart';
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
  // bool allDelivered = false;
  // int leftquantities = 0;
  // checkIfAllDelivered() {
  //   if (widget.items.isNotEmpty) {
  //     for (int i = 0; i < widget.items.length; i++) {
  //       Item it = widget.items[i];
  //       leftquantities += it.quantitySales!;
  //     }
  //     if (leftquantities == 0) {
  //       setState(() {
  //         allDelivered = true;
  //       });
  //     }
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    // checkIfAllDelivered();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NSOrderProvider>(builder: (_, ip, __) {
      SalesOrderModel som =
          ip.som.firstWhere((element) => element.orderID == widget.orderId);
      List<Item> items = som.items!;
      print(widget.orderId);
      print(items.length);
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
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Status',
                      textScaleFactor: 1.2,
                      style: TextStyle(color: b.withOpacity(0.6)),
                    ),
                    Spacer(),
                    // Text(
                    //   allDelivered ? 'All Items Shipped' : 'Ready to pack',
                    //   textScaleFactor: 1.2,
                    //   style: TextStyle(color: dg),
                    // ),
                    Spacer(),
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
                      quantity: items[index].quantitySales.toString(),
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

class SOPShipped extends StatefulWidget {
  const SOPShipped({super.key, required this.orderId});
  final int orderId;

  @override
  State<SOPShipped> createState() => _SOPShippedState();
}

class _SOPShippedState extends State<SOPShipped> {
  @override
  Widget build(BuildContext context) {
    // final itemsDelivered = widget.itemsDelivered ?? [];
    // final reversedList = itemsDelivered.reversed.toList();
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
                        itemName: itemsDelivered[index].itemName!,
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
                            itemName: itemsReturned[index].itemName!,
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
