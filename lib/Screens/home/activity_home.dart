import 'package:ashwani/Screens/home/all_activity_home.dart';
import 'package:ashwani/Screens/home/to_be_delivered.dart';
import 'package:ashwani/Screens/home/to_be_shipped.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class AllHomeActivity extends StatefulWidget {
  const AllHomeActivity({super.key, required this.currentIndex});
  final int currentIndex;

  @override
  State<AllHomeActivity> createState() => _AllHomeActivityState();
}

class _AllHomeActivityState extends State<AllHomeActivity> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: widget.currentIndex,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            // title: Text('Activity'),
            // leading: IconButton(
            //     onPressed: () {
            //       Navigator.pop(context);
            //     },
            //     icon: const Icon(Icons.close)),
            backgroundColor: w,
            elevation: 0.5,
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(00.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabBar(
                      // mouseCursor: MouseCursor.defer,
                        isScrollable: true,
                        unselectedLabelColor: b32,
                        indicatorColor: blue,
                        labelColor: b,
                        tabAlignment: TabAlignment.start,
                        // dividerColor: Colors.black,
                        // labelPadding: EdgeInsets.symmetric(horizontal: widthofTabBarPadding),
                        tabs: const [
                          Tab(
                            child: SizedBox(
                                child: Center(
                                    child: Text(
                              "All",
                              textScaleFactor: 0.8,
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ))),
                          ),
                          Tab(
                            child: SizedBox(
                                child: Center(
                                    child: Text(
                              "Shipped",
                              textScaleFactor: 0.8,
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ))),
                          ),
                          Tab(
                            child: SizedBox(
                                child: Center(
                                    child: Text(
                              "Delivered",
                              textScaleFactor: 0.8,
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ))),
                          ),
                          // Tab(
                          //  child: Text("Items",textScaleFactor: 0.8,style: TextStyle(fontWeight: FontWeight.w400),),
                          // )
                        ]),
                  ],
                )),
          ),
          body: const TabBarView(
            children: <Widget>[
              AllActivityHome(), ToBeShipped(),
              ToBeDelivered()
              // ItemsPage()
            ],
          )),
    );
  }
}


// DefaultTabController(
//               length: 3,
//               initialIndex: 0,
//               child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Material(
//                           color: white,
//                           child: TabBar(
//                             // overlayColor: ,
//                             controller: _tabs,
//                             padding: EdgeInsets.zero,
//                             indicatorPadding: EdgeInsets.zero,
//                             labelPadding:
//                                 const EdgeInsets.only(right: 12, left: 12),
//                             isScrollable: true,
//                             labelStyle: const TextStyle(
//                                 fontWeight: FontWeight.w400, fontSize: 12),
//                             indicatorColor: yellow,
//                             tabs: const [
//                               Tab(
//                                 text: "Active",
//                               ),
//                               Tab(
//                                 text: "Past",
//                               ),
//                               Tab(
//                                 text: "Cancelled",
//                               ),
//                             ],
//                             labelColor: Colors.black,
//                             unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w300),
//                             indicator: MaterialIndicator(
//                               strokeWidth: 0.5,
//                               height: 0.5,
//                               color: orange,
//                               topLeftRadius: 8,
//                               topRightRadius: 8,
//                               horizontalPadding: 0,
//                               paintingStyle: PaintingStyle.fill,
//                               tabPosition: TabPosition.bottom,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 16,
//                         ),
//                       ]))),

//                       Expanded(
//               child: TabBarView( 
//                 controller: _tabs,
//                 children: const [
//              Center(
//               child: PartActiveBooking()
//             ),
//              Center(
//               child: PartPastBooking()
//             ),
//              Center(
//               child: PartCancelledBooking()
//             ),
//           ]))