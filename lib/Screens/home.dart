import 'package:ashwani/Screens/more.dart';
import 'package:ashwani/Screens/settings/setting_page.dart';
import 'package:ashwani/constantWidgets/boxes.dart';
import 'package:ashwani/customer/add_customer.dart';
import 'package:ashwani/items/addItems.dart';
import 'package:ashwani/providers/inventory_summary_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //  getTotal() async{
    
  //   return inventorySummaryProvider.inHand.toString();
  // }

  int currentIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final inventorySummaryProvider =
        Provider.of<InventorySummaryProvider>(context, listen: false);
     inventorySummaryProvider.totalInHand();
  }

  @override
  Widget build(BuildContext context) {
    final inventorySummaryProvider =
        Provider.of<InventorySummaryProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              //top bar with company name and notifications
              Row(
                children: [
                  const CircleAvatar(
                    maxRadius: 20,
                    child: Image(
                      width: 40,
                      height: 40,
                      image: AssetImage('lib/images/logoashapp.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Company Name',
                        textScaleFactor: 1.2,
                      ),
                      Text(
                        'Aryamann',
                        textScaleFactor: 0.8,
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                                builder: (context) => SettingsPage()));
                      },
                      icon: Icon(
                        Icons.settings,
                        size: 30,
                      )),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              //inventory Summary
              Row(
                children: const [
                  Text(
                    'Inventory Summary',
                    style: TextStyle(fontWeight: FontWeight.w500),
                    textScaleFactor: 1.2,
                  ),
                  // const Spacer(),
                  // GestureDetector(
                  //   onTap: () {
                  //     //dialog to change inventory filter
                  //     // showDialog<String>()
                  //   },
                  //   child: Container(
                  //     width: 78,
                  //     height: 26,
                  //     decoration: BoxDecoration(
                  //         color: const Color(0xFFF7F7F7),
                  //         borderRadius: BorderRadius.circular(7)),
                  //     child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //         children: const [
                  //           Text(
                  //             'Weekly',
                  //             style: TextStyle(fontWeight: FontWeight.w300),
                  //             textScaleFactor: 0.8,
                  //           ),
                  //           Icon(
                  //             LineIcons.angleDown,
                  //             size: 12,
                  //           )
                  //         ]),
                  //   ),
                  // )
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ContainerHomeInventory(
                    title: 'Available Stock',
                    amount: inventorySummaryProvider.inHand.toString(),
                  ),
                  ContainerHomeInventory(
                    title: 'To be Recieved',
                    amount: '12',
                  ),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              //activity portion
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trading Activity',
                    style: TextStyle(fontWeight: FontWeight.w500),
                    textScaleFactor: 1.2,
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  ContainerHomeActivity(
                    amt: '0',
                    title: 'Quantity to be Packed',
                    type: 0,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ContainerHomeActivity(
                    amt: '0',
                    title: 'Quantity to be Shipped',
                    type: 1,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ContainerHomeActivity(
                    amt: '0',
                    title: 'Quantity to be Delivered',
                    type: 2,
                  )
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              //more portion
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    ' More',
                    style: TextStyle(fontWeight: FontWeight.w500),
                    textScaleFactor: 1.2,
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  ContainerHomeMore(
                    title: 'Add new items',
                    type: 0,
                    action: AddItems(),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ContainerHomeMore(
                    title: 'Add new costumer',
                    type: 1,
                    action: AddCustomer(),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ContainerHomeMore(
                    title: 'More',
                    type: 1,
                    action: MoreFromHomePage(),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

enum inventoryFilter {
  daily,
  weekly,
  monthly,
  yearly,
}
