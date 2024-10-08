import 'package:ashwani/src/Screens/purchase/purchase_activity.dart';
import 'package:ashwani/src/Screens/purchase/purchase_orders.dart';
import 'package:ashwani/src/Screens/purchase/purchase_returns.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({super.key});

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: w,
            elevation: 0.5,
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0.0),
                child: TabBar(
                    isScrollable: true,
                    unselectedLabelColor: b32,
                    indicatorColor: blue,
                    labelColor: b,
                    tabAlignment: TabAlignment.center,
                    // dividerColor: Colors.black,
                    // labelPadding: EdgeInsets.symmetric(horizontal: widthofTabBarPadding),
                    tabs: const [
                      Tab(
                        child: SizedBox(
                            child: Center(
                                child: Text(
                          "Purchase Orders",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 10),
                        ))),
                      ),
                      Tab(
                        child: SizedBox(
                            child: Center(
                                child: Text(
                          "Purchase Activity",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 10),
                        ))),
                      ),
                      Tab(
                        child: SizedBox(
                            child: Center(
                                child: Text(
                          "Purchase Returns",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 10),
                        ))),
                      ),
                      // Tab(
                      //  child: Text("Items",textScaleFactor: 0.8,style: TextStyle(fontWeight: FontWeight.w400),),
                      // )
                    ])),
          ),
          body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              PurchaseOrders(), PurchaseActivity(),
              PurchaseReturns()
              // ItemsPage()
            ],
          )),
    );
  }
}
