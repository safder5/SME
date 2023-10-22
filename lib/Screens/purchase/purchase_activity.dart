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
  List<ItemTrackingPurchaseOrder> paList = [];
  bool isloading = true;
  bool isDisposed = false;
  bool hasData = false;
  chackProviderforData() {
    final poProvider = Provider.of<NPOrderProvider>(context, listen: false);
    if (poProvider.pa.isNotEmpty) {
      if (!isDisposed) {
        setState(() {
          isloading = false;
          hasData = true;
          paList = poProvider.pa.reversed.toList();
        });
      } 
    }
  }
  Future<void> fetchPurchaseActivity(BuildContext context) async {
    final poProvider = Provider.of<NPOrderProvider>(context, listen: false);

    try {
      await poProvider.fetchPurchaseActivity();
      if (!isDisposed && !hasData) {
        setState(() {
          paList = poProvider.pa.reversed.toList();
          isloading = false;
        });
      }
    } catch (e) {
      // Handle the error
      if (!isDisposed) {
        setState(() {
          isloading = false;
        });
      }
      print('Error fetching sales orders: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chackProviderforData();
    fetchPurchaseActivity(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: w,
      // floatingActionButton: FloatingActionButton(
      //     heroTag: '/newPurchaseOrder',
      //     // elevation: 0,
      //     tooltip: 'New Purchase Order',
      //     backgroundColor: blue,
      //     child: const Center(
      //       child: Icon(
      //         LineIcons.plus,
      //         size: 30,
      //       ),
      //     ),
      //     onPressed: () {
      //       Navigator.of(context, rootNavigator: true).push(
      //           MaterialPageRoute(builder: (context) => NewPurchaseOrder()));
      //       // Navigator.push(context,
      //       //     MaterialPageRoute(builder: (context) => NewSalesOrder()));
      //     }),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                //   child: Container(
                //     height: 36,
                //     width: double.maxFinite,
                //     decoration: BoxDecoration(
                //         color: b.withOpacity(0.03),
                //         borderRadius: BorderRadius.circular(5)),
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 12.0),
                //       //here is the SEARCH BAR
                //       child: Row(
                //         children: [
                //           Text(
                //             'Search Name or Order No.',
                //             style: TextStyle(color: b.withOpacity(0.2)),
                //             textScaleFactor: 0.8,
                //           ),
                //           const Spacer(),
                //           Transform(
                //               alignment: Alignment.center,
                //               transform: Matrix4.rotationY(math.pi),
                //               child: Icon(
                //                 LineIcons.search,
                //                 color: b.withOpacity(0.2),
                //                 size: 18,
                //               )),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 16,
                // ),
                //future builder to build purchase orders
                Expanded(
                  child: ListView.builder(
                      // physics: controllScroll,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: paList.length,
                      itemBuilder: (context, index) {
                        final purchaseOrder = paList[index];
                        return PurchaseActivityTile(activity: purchaseOrder,
                            );
                      }),
                ),
              ],
            ),
          ),
          if (isloading) LoadingOverlay()
        ],
      ),
    );
  }
}
