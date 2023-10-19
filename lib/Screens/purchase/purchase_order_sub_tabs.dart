import 'package:flutter/material.dart';

import '../../Models/iq_list.dart';
import '../../constantWidgets/boxes.dart';
import '../../constants.dart';

class POPDetails extends StatelessWidget {
   const POPDetails({super.key, required this.items});
   final List<Item>? items;
  @override
  Widget build(BuildContext context) {
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
                  Spacer(),
                  Text(
                    'Order Placed',
                    textScaleFactor: 1.2,
                    style: TextStyle(color: dg),
                  ),
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
                      name: items![index].itemName!,
                      quantity: items![index].itemQuantity.toString(),
                      index: index);
                },
                itemCount: items?.length?? 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class POPRecieved extends StatelessWidget {
   List<ItemTrackingPurchaseOrder>? itemsRecieved;
   POPRecieved({super.key,this.itemsRecieved});

  @override
  Widget build(BuildContext context) {
    itemsRecieved ??= [];
    itemsRecieved = itemsRecieved!.reversed.toList();
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
                      quantity: itemsRecieved![index]
                          .quantityRecieved
                          .toString(),
                      itemName: itemsRecieved![index].itemName,
                      quantityReturned: itemsRecieved![index].quantityReturned,
                      index: index);
                },
                itemCount: itemsRecieved?.length ?? 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class POPReturns extends StatelessWidget {
  List<ItemTrackingPurchaseOrder>? itemsReturned;
   POPReturns({super.key,this.itemsReturned});

  @override
  Widget build(BuildContext context) {
   itemsReturned ??= [];
    itemsReturned = itemsReturned!.reversed.toList();
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
                      itemName: itemsReturned![index].itemName,
                      quantityReturned: itemsReturned![index].quantityReturned,
                      index: index);
                },
                itemCount: itemsReturned?.length ?? 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
