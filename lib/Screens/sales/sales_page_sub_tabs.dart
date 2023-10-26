import 'package:ashwani/constantWidgets/boxes.dart';
import 'package:ashwani/constants.dart';
import 'package:ashwani/Models/iq_list.dart';
import 'package:flutter/material.dart';

class SOPDetails extends StatefulWidget {
  const SOPDetails({super.key, required this.items});
  final List<Item> items;

  @override
  State<SOPDetails> createState() => _SOPDetailsState();
}

class _SOPDetailsState extends State<SOPDetails> {
  bool allDelivered = false;
  int leftquantities = 0;
  checkIfAllDelivered() {
    if (widget.items.isNotEmpty) {
      for (int i = 0; i < widget.items.length; i++) {
        Item it = widget.items[i];
        leftquantities += it.quantitySales!;
      }
      if(leftquantities == 0){
        setState(() {
          allDelivered = true;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfAllDelivered();
  }

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
                    allDelivered? 'All Items Shipped':'Ready to pack',
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
                      name: widget.items[index].itemName!,
                      quantity: widget.items[index].quantitySales.toString(),
                      index: index, original: widget.items[index].originalQuantity?? 0,);
                },
                itemCount: widget.items.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SOPShipped extends StatefulWidget {
  final List<Item>? itemsDelivered;

  const SOPShipped({super.key, this.itemsDelivered});

  @override
  State<SOPShipped> createState() => _SOPShippedState();
}

class _SOPShippedState extends State<SOPShipped> {
  @override
  Widget build(BuildContext context) {
    final itemsDelivered = widget.itemsDelivered ?? [];
    final reversedList = itemsDelivered.reversed.toList();
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
                      quantity:
                          reversedList[index].quantitySalesDelivered.toString(),
                      itemName: reversedList[index].itemName!,
                      quantityReturned:
                          reversedList[index].quantitySalesReturned?? 0,
                      index: index);
                },
                itemCount: reversedList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SOPReturns extends StatefulWidget {
  final List<Item>? itemsReturned;
  const SOPReturns({super.key, this.itemsReturned});

  @override
  State<SOPReturns> createState() => _SOPReturnsState();
}

class _SOPReturnsState extends State<SOPReturns> {
  @override
  Widget build(BuildContext context) {
    final itemsReturned = widget.itemsReturned ?? [];
    final reversedList = itemsReturned.reversed.toList();
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
            reversedList.isEmpty
                ? Container()
                : Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return SOReturnsItemTile(
                          quantity: reversedList[index]
                              .quantitySalesReturned
                              .toString(),
                          itemName: reversedList[index].itemName!,
                          index: index,
                        );
                      },
                      itemCount: reversedList.length,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
