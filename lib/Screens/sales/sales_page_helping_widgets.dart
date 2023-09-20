import 'package:ashwani/constantWidgets/boxes.dart';
import 'package:ashwani/constants.dart';
import 'package:ashwani/model/iq_list.dart';
import 'package:flutter/material.dart';

class SOPDetails extends StatefulWidget {
  const SOPDetails({super.key, required this.items});
  final List<Item> items;
  @override
  State<SOPDetails> createState() => _SOPDetailsState();
}

class _SOPDetailsState extends State<SOPDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.height * 0.66) - 70,
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
                    'Items Packed',
                    textScaleFactor: 1.2,
                    style: TextStyle(color: dg),
                  ),
                  Spacer(),
                ],
              ),
            ),
             Divider(height: 0,color: b32,thickness: 0.2,),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return SOPDetailsItemTile(
                      name: widget.items[index].itemName!,
                      quantity: widget.items[index].itemQuantity.toString(),
                      index: index);
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
  const SOPShipped({super.key});

  @override
  State<SOPShipped> createState() => _SOPShippedState();
}

class _SOPShippedState extends State<SOPShipped> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}

class SOPReturns extends StatefulWidget {
  const SOPReturns({super.key});

  @override
  State<SOPReturns> createState() => _SOPReturnsState();
}

class _SOPReturnsState extends State<SOPReturns> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView();
  }
}
