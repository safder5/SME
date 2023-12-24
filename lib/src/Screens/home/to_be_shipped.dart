import 'package:ashwani/src/Providers/new_sales_order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constantWidgets/boxes.dart';
import '../sales/sales_order_page.dart';

class ToBeShipped extends StatefulWidget {
  const ToBeShipped({super.key});

  @override
  State<ToBeShipped> createState() => _ToBeShippedState();
}

class _ToBeShippedState extends State<ToBeShipped> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NSOrderProvider>(builder: (_, prov, __) {
      final orders = prov.som;
      final tbsOrders =
          orders.where((element) => element.itemsDelivered == null ).toList();
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: tbsOrders.length,
                      itemBuilder: (context, index) {
                        final salesOrder = tbsOrders[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .push(MaterialPageRoute(
                                    builder: (context) => SalesOrderPage(
                                          orderId: salesOrder.orderID ?? 0,
                                        )));
                          },
                          child: ContainerSalesOrder(
                              orderID: salesOrder.orderID.toString(),
                              name: salesOrder.customerName!,
                              date: salesOrder.shipmentDate!,
                              status: salesOrder.status!),
                        );
                      })),
            ],
          ),
        ),
      );
    });
  }
}
