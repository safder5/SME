import 'package:ashwani/src/Providers/new_purchase_order_provider.dart';
import 'package:ashwani/src/constantWidgets/boxes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PurchaseActivity extends StatefulWidget {
  const PurchaseActivity({super.key});

  @override
  State<PurchaseActivity> createState() => _PurchaseActivityState();
}

class _PurchaseActivityState extends State<PurchaseActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Consumer<NPOrderProvider>(
                  builder: (_, pa, __) {
                    final paList = pa.pa.reversed.toList();
                    return Expanded(
                      child: ListView.builder(
                          // physics: controllScroll,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: paList.length,
                          itemBuilder: (context, index) {
                            final purchaseOrder = paList[index];
                            return PurchaseActivityTile(
                              activity: purchaseOrder,
                            );
                          }),
                    );
                  },
                )
                //future builder to build purchase orders
              ],
            ),
          ),
        ],
      ),
    );
  }
}
