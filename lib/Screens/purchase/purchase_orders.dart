import 'package:ashwani/Screens/newOrders/new_purchase_order.dart';
import 'package:ashwani/constants.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:math' as math;

class PurchaseOrders extends StatefulWidget {
  const PurchaseOrders({super.key});

  @override
  State<PurchaseOrders> createState() => _PurchaseOrdersState();
}

class _PurchaseOrdersState extends State<PurchaseOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: w,
      floatingActionButton: FloatingActionButton(
          // elevation: 0,
          tooltip: 'New Purchase Order',
          backgroundColor: blue,
          child: const Center(
            child: Icon(
              LineIcons.plus,
              size: 30,
            ),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => NewPurchaseOrder()));
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => NewSalesOrder()));
          }),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                height: 36,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: b.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  //here is the SEARCH BAR
                  child: Row(
                    children: [
                      Text(
                        'Search Name or Order No.',
                        style: TextStyle(color: b.withOpacity(0.2)),
                        textScaleFactor: 0.8,
                      ),
                      const Spacer(),
                      Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: Icon(
                            LineIcons.search,
                            color: b.withOpacity(0.2),
                            size: 18,
                          )),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            //future builder to build purchase orders
          ],
        ),
      ),
    );
  }
}
