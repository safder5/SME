import 'package:ashwani/Screens/newOrders/new_sales_order.dart';
import 'package:ashwani/Screens/sales/sales_order_page.dart';
import 'package:ashwani/constantWidgets/boxes.dart';
import 'package:ashwani/constants.dart';
import 'package:ashwani/Providers/new_sales_order_provider.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class SalesOrders extends StatefulWidget {
  const SalesOrders({super.key});

  @override
  State<SalesOrders> createState() => _SalesOrdersState();
}

class _SalesOrdersState extends State<SalesOrders> {
  @override
  Widget build(BuildContext context) {
    final soProvider = Provider.of<NSOrderProvider>(context);
    return Scaffold(
      backgroundColor: w,
      floatingActionButton: FloatingActionButton(
        heroTag: null,
          // elevation: 0,
          tooltip: 'New Sales Order',
          backgroundColor: blue,
          child: const Center(
            child: Icon(
              LineIcons.plus,
              size: 30,
            ),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(builder: (context) => NewSalesOrder()));
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
                          ))
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            FutureBuilder(
                future: soProvider.fetchSalesOrders(),
                builder: (context, snapshot) {
                  // if (snapshot.connectionState == ConnectionState.waiting) {
                  //   return const CircularProgressIndicator();
                  // }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: soProvider.som.length,
                          itemBuilder: (context, index) {
                            final salesOrder = soProvider.som[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true).push(
                                    MaterialPageRoute(
                                        builder: (context) => SalesOrderPage(
                                            salesorder: salesOrder)));
                              },
                              child: ContainerSalesOrder(
                                  orderID: salesOrder.orderID.toString(),
                                  name: salesOrder.customerName!,
                                  date: salesOrder.shipmentDate!,
                                  status: salesOrder.status!),
                            );
                          }),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
