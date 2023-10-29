import 'package:ashwani/Models/iq_list.dart';
import 'package:ashwani/Providers/new_purchase_order_provider.dart';
import 'package:ashwani/Services/helper.dart';
import 'package:ashwani/constantWidgets/boxes.dart';
import 'package:ashwani/constants.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:math' as math;

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
      backgroundColor: w,
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
