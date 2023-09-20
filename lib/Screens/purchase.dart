import 'package:ashwani/Screens/purchase/purchase_orders.dart';
import 'package:ashwani/Screens/purchase/purchase_returns.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({super.key});

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
                    // dividerColor: Colors.black,
                    // labelPadding: EdgeInsets.symmetric(horizontal: widthofTabBarPadding),
                    tabs: [
                      Tab(
                        child: SizedBox(
                          width:  MediaQuery.of(context).size.width*0.4,
                          child: Center(child: Text("Purchase Orders",textScaleFactor: 0.8,style: TextStyle(fontWeight: FontWeight.w400),))),
                      ),
                      Tab(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width*0.4,
                          child: Center(child: Text("Purchase Returns",textScaleFactor: 0.8,style: TextStyle(fontWeight: FontWeight.w400),))),
                      ),
                      // Tab(
                      //  child: Text("Items",textScaleFactor: 0.8,style: TextStyle(fontWeight: FontWeight.w400),),
                      // )
                    ])),
          ),
          body: const TabBarView(
            children: <Widget>[
              PurchaseOrders(),
              PurchaseReturns()
              // ItemsPage()
            ],
          )),
    );
  }
}