
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/new_purchase_order_provider.dart';
import '../../constantWidgets/boxes.dart';

class PurchaseActivity extends StatelessWidget {
  const PurchaseActivity({super.key});

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
