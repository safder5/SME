import 'package:ashwani/src/Screens/sales/sales_activity.dart';
import 'package:ashwani/src/Screens/sales/sales_orders.dart';
import 'package:ashwani/src/Screens/sales/sales_returns.dart';
import 'package:ashwani/src/constants.dart';
import 'package:flutter/material.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  @override
  Widget build(BuildContext context) {
    // double widthofTabBarPadding = MediaQuery.of(context).size.width/8;
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
                    // dividerColor: Colors.black,
                    // labelPadding: EdgeInsets.symmetric(horizontal: widthofTabBarPadding),
                    tabs: const [
                      Tab(
                        child: SizedBox(
                            child: Center(
                                child: Text(
                          "Sales Orders",
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
                        ))),
                      ),
                      Tab(
                        child: SizedBox(
                            child: Center(
                                child: Text(
                          "Sales Activity",
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
                        ))),
                      ),
                      Tab(
                        child: SizedBox(
                            child: Center(
                                child: Text(
                          "Sales Returns",
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
                        ))),
                      ),
                      // Tab(
                      //  child: Text("Items",textScaleFactor: 0.8,style: TextStyle(fontWeight: FontWeight.w400),),
                      // )
                    ])),
          ),
          body: const TabBarView(
            children: <Widget>[
              SalesOrders(), 
              SalesActivity(),
              SalesReturns(),
              // ItemsPage()
            ],
          )),
    );
  }
}
