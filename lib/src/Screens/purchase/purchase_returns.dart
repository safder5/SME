import 'package:ashwani/src/Models/iq_list.dart';
import 'package:ashwani/src/Providers/purchase_returns_provider.dart';
import 'package:ashwani/src/constantWidgets/boxes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PurchaseReturns extends StatelessWidget {
  const PurchaseReturns({super.key});

  @override
  Widget build(BuildContext context) {
    final prProvider = Provider.of<PurchaseReturnsProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  List<PurchaseReturnItemTracking> prList = pr.pr;
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
