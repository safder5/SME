import 'package:flutter/material.dart';

import '../../Models/iq_list.dart';
import '../../constantWidgets/boxes.dart';
import '../../constants.dart';

class POPDetails extends StatelessWidget {
   POPDetails({super.key, this.items});
   List<Item>? items;
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

class POPRecieved extends StatefulWidget {
  const POPRecieved({super.key});

  @override
  State<POPRecieved> createState() => _POPRecievedState();
}

class _POPRecievedState extends State<POPRecieved> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class POPReturns extends StatefulWidget {
  const POPReturns({super.key});

  @override
  State<POPReturns> createState() => _POPReturnsState();
}

class _POPReturnsState extends State<POPReturns> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
