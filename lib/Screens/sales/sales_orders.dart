import 'package:ashwani/Models/sales_order.dart';
import 'package:ashwani/Screens/newOrders/new_sales_order.dart';
import 'package:ashwani/Screens/sales/sales_order_page.dart';
import 'package:ashwani/constantWidgets/boxes.dart';
import 'package:ashwani/constants.dart';
import 'package:ashwani/Providers/new_sales_order_provider.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

import '../../Providers/iq_list_provider.dart';

class SalesOrders extends StatefulWidget {
  const SalesOrders({super.key});

  @override
  State<SalesOrders> createState() => _SalesOrdersState();
}

class _SalesOrdersState extends State<SalesOrders> {
  final ClampingScrollPhysics controllScroll = const ClampingScrollPhysics();
  List<SalesOrderModel> soList = [];
  List<String> customerNames = [];
  bool isLoading = true;
  bool _isDisposed = false;
  bool hasData = false;

  checkProviderForData() {
    final soProvider = Provider.of<NSOrderProvider>(context, listen: false);
    if (soProvider.som.isNotEmpty) {
      if (!_isDisposed) {
        setState(() {
          isLoading = false;
          hasData = true;
          soList = soProvider.som.reversed.toList();
        });
      }
    } else {
      print('fetching orders');
      fetchSalesOrders(context);
    }
  }

  Future<void> fetchSalesOrders(BuildContext context) async {
    final soProvider = Provider.of<NSOrderProvider>(context, listen: false);

    try {
      await soProvider.fetchSalesOrders();
      print(soProvider.som.length);
      if (!_isDisposed && !hasData) {
        setState(() {
          soList = soProvider.som.reversed.toList();
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle the error
      if (!_isDisposed) {
        setState(() {
          isLoading = false; // Stop loading when an error occurs
        });
      }
      print('Error fetching sales orders: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch sales orders and update the list

    soList = [];
    // checkProviderForData();

    // fetchSalesOrders(context);
    // fetchCustomerNames(context);
  }

  @override
  void dispose() {
    // Cancel or dispose of asynchronous operations here
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final soProvider = Provider.of<NSOrderProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
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
            Provider.of<ItemsProvider>(context, listen: false).clearsoItems();
            Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(builder: (context) => const NewSalesOrder()));
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => NewSalesOrder()));
          }),
      body: Stack(
        children: [
          Padding(
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
                // Expanded(
                //   child: ListView.builder(
                //       // physics: controllScroll,
                //       shrinkWrap: true,
                //       scrollDirection: Axis.vertical,
                //       itemCount: soList.length,
                //       itemBuilder: (context, index) {
                //         final salesOrder = soList[index];
                //         return GestureDetector(
                //           onTap: () {
                //             Navigator.of(context, rootNavigator: true).push(
                //                 MaterialPageRoute(
                //                     builder: (context) => SalesOrderPage(
                //                         salesorder: salesOrder)));
                //           },
                //           child: ContainerSalesOrder(
                //               orderID: salesOrder.orderID.toString(),
                //               name: salesOrder.customerName!,
                //               date: salesOrder.shipmentDate!,
                //               status: salesOrder.status!),
                //         );
                //       }),
                // ),
                Consumer<NSOrderProvider>(builder: (_, provider, __) {
                  final salesOrders = provider.som.reversed.toList();
                  // print(salesOrders.length);
                  if (salesOrders.isEmpty) {
                    return const Center(
                      child: Text('No Customers yet, Add Below '),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: salesOrders.length,itemBuilder: (context, index) {
                      final salesOrder = salesOrders[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SalesOrderPage(orderId: salesOrder.orderID??0,)));
                        },
                        child: ContainerSalesOrder(
                            orderID: salesOrder.orderID.toString(),
                            name: salesOrder.customerName!,
                            date: salesOrder.shipmentDate!,
                            status: salesOrder.status!),
                      );
                    }),
                  );
                })
              ],
            ),
          ),
          // if (isLoading) LoadingOverlay()
        ],
      ),
    );
  }
}
