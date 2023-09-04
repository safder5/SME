import 'package:ashwani/Screens/sales/sales_orders.dart';
import 'package:ashwani/Screens/sales/sales_returns.dart';
import 'package:ashwani/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:line_icons/line_icons.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  @override
  Widget build(BuildContext context) {
    double widthofTabBarPadding = MediaQuery.of(context).size.width/8;
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
                    tabs: const[
                      Tab(
                        child: Text("Sales Orders",textScaleFactor: 0.8,style: TextStyle(fontWeight: FontWeight.w400),),
                      ),
                      Tab(
                        child: Text("Sales Returns",textScaleFactor: 0.8,style: TextStyle(fontWeight: FontWeight.w400),),
                      ),
                    ])),
          ),
          body: const TabBarView(
            children: <Widget>[
              SalesOrders(),
              SalesReturns(),
            ],
          )),
    );
  }
}
