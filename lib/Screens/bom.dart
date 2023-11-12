import 'package:ashwani/Screens/bom/bom_screen.dart';
import 'package:ashwani/Screens/bom/production.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class BOM extends StatefulWidget {
  const BOM({super.key});

  @override
  State<BOM> createState() => _BOMState();
}

class _BOMState extends State<BOM> {
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
                  labelPadding: const EdgeInsets.symmetric(horizontal: 50),
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
                          "Your BOMs",
                          textScaleFactor: 0.8,
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ))),
                      ),
                      Tab(
                        child: SizedBox(
                            child: Center(
                                child: Text(
                          "Production",
                          textScaleFactor: 0.8,
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ))),
                      ),
                      // Tab(
                      //  child: Text("Items",textScaleFactor: 0.8,style: TextStyle(fontWeight: FontWeight.w400),),
                      // )
                    ])),
          ),
          body: const TabBarView(
            children: <Widget>[
             BomScreen(),
             Production()
              // ItemsPage()
            ],
          )),
    );
  }
}
