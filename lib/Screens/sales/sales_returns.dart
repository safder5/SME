import 'package:ashwani/Providers/sales_returns_provider.dart';
import 'package:ashwani/constantWidgets/boxes.dart';
import 'package:ashwani/constants.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class SalesReturns extends StatefulWidget {
  const SalesReturns({super.key});

  @override
  State<SalesReturns> createState() => _SalesReturnsState();
}

class _SalesReturnsState extends State<SalesReturns> {
  // List<SalesReturnItemTracking> srList = [];
  // List<String> customerNames = [];
  // bool isLoading = true;
  // bool _isDisposed = false;

  // @override
  // void initState() {
  //   super.initState();
  //   // Fetch sales orders and update the list
  //   fetchSalesReturns(context);
  //   // fetchCustomerNames(context);
  // }

  // Future<void> fetchSalesReturns(BuildContext context) async {
  //   final srProvider =
  //       Provider.of<SalesReturnsProvider>(context, listen: false);
  //   try {
  //     await srProvider.fetchSalesReturns();
  //     if (!_isDisposed) {
  //       setState(() {
  //         srList = srProvider.sr;
  //         isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     if (!_isDisposed) {
  //       setState(() {
  //         isLoading = false; // Stop loading when an error occurs
  //       });
  //       print('Error fetching sales orders: $e');
  //     }
  //     // Handle the error
  //     print('Error fetching sales returns: $e');
  //   }
  // }

  // @override
  // void dispose() {
  //   // Cancel or dispose of asynchronous operations here
  //   _isDisposed = true;
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final srProvider = Provider.of<SalesReturnsProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                Consumer<SalesReturnsProvider>(builder: ((context, sr, child) {
                  final srList = sr.sr.reversed.toList();
                 return Expanded(
                    child: ListView.builder(
                        // physics: controllScroll,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: srList.length,
                        itemBuilder: (context, index) {
                          final salesReturn = srProvider.sr[index];
                          // print(salesReturn.itemname);
                          return ContainerSalesReturn(
                            itemname: salesReturn.itemname,
                            orderId: salesReturn.orderId,
                            quantity: salesReturn.quantitySalesReturned!,
                            toInventory: salesReturn.toInventory!,
                          );
                        }),
                  );
                }))
              ],
            ),
          ),
        
        ],
      ),
    );
  }
}
