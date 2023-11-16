import 'package:ashwani/constantWidgets/boxes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/new_purchase_order_provider.dart';
import '../purchase/purchase_order_page.dart';

class ToBeRecieved extends StatefulWidget {
  const ToBeRecieved({super.key});

  @override
  State<ToBeRecieved> createState() => _ToBeRecievedState();
}

class _ToBeRecievedState extends State<ToBeRecieved> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NPOrderProvider>(builder: (_, prov, __) {
      final orders = prov.po;
      final tbrOrders =
          orders.where((element) => element.itemsRecieved == null).toList();
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: tbrOrders.length,
                      itemBuilder: (context, index) {
                        final purchaseOrder = tbrOrders[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .push(MaterialPageRoute(
                                    builder: (context) => PurchaseOrderPage(
                                          orderId: purchaseOrder.orderID,
                                        )));
                          },
                          child: ContainerPurchaseOrder(
                              orderID: purchaseOrder.orderID.toString(),
                              name: purchaseOrder.vendorName!,
                              date: purchaseOrder.deliveryDate!,
                              status: purchaseOrder.status!),
                        );
                      })),
            ],
          ),
        ),
      );
    });
  }
}
