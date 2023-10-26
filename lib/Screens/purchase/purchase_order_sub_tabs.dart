import 'package:flutter/material.dart';

import '../../Models/iq_list.dart';
import '../../constantWidgets/boxes.dart';
import '../../constants.dart';

class POPDetails extends StatefulWidget {
  const POPDetails({super.key, required this.items});
  final List<Item> items;

  @override
  State<POPDetails> createState() => _POPDetailsState();
}

class _POPDetailsState extends State<POPDetails> {
  bool allRecieved = false;
  int qrecieved = 0;

  checkAllRecieved() {
     if (widget.items.isNotEmpty) {
      for (int i = 0; i < widget.items.length; i++) {
        Item it = widget.items[i];
        qrecieved += it.itemQuantity!;
      }
      if(qrecieved == 0){
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
                  Text(
                    allRecieved? 'All Recieved':'Order Placed',
                    textScaleFactor: 1.2,
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
                  return SOPDetailsItemTile(
                      name: widget.items![index].itemName!,
                      quantity: widget.items![index].itemQuantity.toString(),
                      index: index, original: widget.items![index].originalQuantity ?? 0,);
                },
                itemCount: widget.items?.length ?? 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class POPRecieved extends StatefulWidget {
  final List<ItemTrackingPurchaseOrder>? itemsRecieved;
  const POPRecieved({super.key, this.itemsRecieved});

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
    final itemsRecieved = widget.itemsRecieved ?? [];
    final reversedItems = itemsRecieved.reversed.toList();
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
                      quantity:
                          reversedItems[index].quantityRecieved.toString(),
                      itemName: reversedItems[index].itemName,
                      quantityReturned: reversedItems[index].quantityReturned,
                      index: index);
                },
                itemCount: itemsRecieved.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class POPReturns extends StatefulWidget {
  final List<ItemTrackingPurchaseOrder>? itemsReturned;
  const POPReturns({super.key, this.itemsReturned});

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
    final itemsReturned = widget.itemsReturned ?? [];
    final itemsReversed = itemsReturned.reversed.toList();
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
                      itemName: itemsReversed[index].itemName,
                      quantityReturned: itemsReversed[index].quantityReturned,
                      index: index);
                },
                itemCount: itemsReturned.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
