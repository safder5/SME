import 'package:ashwani/Providers/purchase_returns_provider.dart';
import 'package:ashwani/constantWidgets/boxes.dart';
import 'package:ashwani/constants.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;


class PurchaseReturns extends StatefulWidget {
  const PurchaseReturns({super.key});

  @override
  State<PurchaseReturns> createState() => _PurchaseReturnsState();
}

class _PurchaseReturnsState extends State<PurchaseReturns> {
  @override
  Widget build(BuildContext context) {
    final prProvider = Provider.of<PurchaseReturnsProvider>(context);
    return Scaffold(
      backgroundColor: w,
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
                //               ))
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 16,
                // ),
                Consumer<PurchaseReturnsProvider>(builder: (_, pr, __) {
                  final prList = pr.pr.reversed.toList();
                  return Expanded(
                    child: ListView.builder(
                        // physics: controllScroll,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: prList.length,
                        itemBuilder: (context, index) {
                          final salesReturn = prProvider.pr[index];
                          return ContainerPurchaseReturn(
                            itemname: salesReturn.itemname,
                            orderId: salesReturn.orderId,
                            quantity: salesReturn.quantity!,
                          );
                        }),
                  );
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
