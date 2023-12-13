import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/new_sales_order_provider.dart';
import '../../constantWidgets/boxes.dart';

class SalesActivity extends StatefulWidget {
  const SalesActivity({super.key});

  @override
  State<SalesActivity> createState() => _SalesActivityState();
}

class _SalesActivityState extends State<SalesActivity> {
  // List<ItemTrackingSalesOrder> saList = [];
  // bool isloading = true;
  // bool isDisposed = false;
  // bool hasData = false;
  // chackProviderforData() {
  //   final soProvider = Provider.of<NSOrderProvider>(context, listen: false);
  //   if (soProvider.sa.isNotEmpty) {
  //     if (!isDisposed) {
  //       setState(() {
  //         isloading = false;
  //         hasData = true;
  //         saList = soProvider.sa.reversed.toList();
  //       });
  //     }
  //   }
  // }

  // Future<void> fetchPurchaseActivity(BuildContext context) async {
  //   final soProvider = Provider.of<NSOrderProvider>(context, listen: false);

  //   try {
  //     await soProvider.fetchActivity();
  //     if (!isDisposed && !hasData) {
  //       setState(() {
  //         saList = soProvider.sa.reversed.toList();
  //         isloading = false;
  //       });
  //     }
  //   } catch (e) {
  //     // Handle the error
  //     if (!isDisposed) {
  //       setState(() {
  //         isloading = false;
  //       });
  //     }
  //     print('Error fetching sales orders: $e');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // chackProviderforData();
    // fetchPurchaseActivity(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                //future builder to build purchase orders
                Consumer<NSOrderProvider>(builder: (_,sa,__){
                  final saList = sa.sa.reversed.toList();
                  return Expanded(
                  child: ListView.builder(
                      // physics: controllScroll,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: saList.length,
                      itemBuilder: (context, index) {
                        final salesOrder = saList[index];
                        return SalesActivityTile(
                          activity: salesOrder,
                        );
                      }),
                );
                })
                
              ],
            ),
          ),
          // if (isloading) LoadingOverlay()
        ],
      ),
    );
  }
}
