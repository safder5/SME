import 'package:ashwani/constantWidgets/boxes.dart';
import 'package:ashwani/constants.dart';
import 'package:ashwani/Models/iq_list.dart';
import 'package:flutter/material.dart';

class SOPDetails extends StatelessWidget {
  SOPDetails({super.key, this.items});
  List<Item>? items;
  @override
  Widget build(BuildContext context) {
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
                  Text(
                    'Ready to pack',
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
                      quantity: items![index].quantitySales.toString(),
                      index: index);
                },
                itemCount: items?.length ?? 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SOPShipped extends StatelessWidget {
  List<Item>? itemsDelivered;

  SOPShipped({super.key, this.itemsDelivered});

  @override
  Widget build(BuildContext context) {
    itemsDelivered ??= [];
    itemsDelivered = itemsDelivered!.reversed.toList();
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
                      quantity: itemsDelivered![index]
                          .quantitySalesDelivered
                          .toString(),
                      itemName: itemsDelivered![index].itemName!,
                      quantityReturned: itemsDelivered![index].quantitySalesReturned!,
                      index: index);
                },
                itemCount: itemsDelivered?.length ?? 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SOPReturns extends StatelessWidget {
  List<Item>? itemsReturned;
  SOPReturns({super.key, this.itemsReturned});

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
            itemsReturned == null
                ? Container()
                : Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return SOReturnsItemTile(
                            quantity: itemsReturned![index]
                                .quantitySalesReturned
                                .toString(),
                            itemName: itemsReturned![index].itemName!,
                            index: index,);
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
