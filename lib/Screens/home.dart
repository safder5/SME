import 'package:ashwani/Screens/home/activity_home.dart';
import 'package:ashwani/Screens/more.dart';
import 'package:ashwani/Screens/settings/setting_page.dart';
import 'package:ashwani/Utils/Vendors/add_vendors.dart';
import 'package:ashwani/constantWidgets/boxes.dart';
import 'package:ashwani/Utils/customers/add_customer.dart';
import 'package:ashwani/Utils/items/add_items.dart';
import 'package:ashwani/Providers/inventory_summary_provider.dart';
import 'package:ashwani/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int totalInHand = 0;
  int totaltobeRecieved = 0;
  int currentIndex = 0;
  // bool isLoading = true;
  bool isDisposed = false;
  bool hasData = false;

  final _auth = FirebaseAuth.instance.currentUser;

  // Future<void> getRequiredHomeData() async {
  //   final inventorySummaryProvider =
  //       Provider.of<InventorySummaryProvider>(context, listen: false);
  //   await inventorySummaryProvider.totalInHand();
  //   await inventorySummaryProvider.totalTobeRecieved();
  //   if (!isDisposed) {
  //     setState(() {
  //       totalInHand = inventorySummaryProvider.inHand;
  //       totaltobeRecieved = inventorySummaryProvider.toRecieve;
  //       isLoading = false;
  //     });
  //   }
  // }

  // checkforProviderData() {
  //   final inventorySummaryProvider =
  //       Provider.of<InventorySummaryProvider>(context, listen: false);
  //   if (inventorySummaryProvider.inHand != 0 ||
  //       inventorySummaryProvider.toRecieve != 0) {
  //     if (!isDisposed) {
  //       setState(() {
  //         hasData = true;
  //         isLoading = false;
  //       });
  //     }
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   checkforProviderData();
  //   getRequiredHomeData();
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<InventorySummaryProvider>(builder: (_, prov, __) {
      final toRecieve = prov.toRecieve;
      final instock = prov.inHand;
      return Scaffold(
        backgroundColor: w,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(children: [
                //top bar with company name and notifications
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Container(
                    decoration: BoxDecoration(
                      color: w,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      //             boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.black.withOpacity(0.5),
                      //     spreadRadius: 2,
                      //     blurRadius: 3,
                      //     offset: Offset(0, 2),
                      //   ),
                      // ],
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  maxRadius: 20,
                                  child: Image(
                                    width: 40,
                                    height: 40,
                                    image:
                                        AssetImage('lib/images/logoashapp.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Company Name',
                                      textScaleFactor: 1.2,
                                    ),
                                    Text(
                                      _auth!.email ?? 'Name',
                                      textScaleFactor: 0.8,
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const SettingsPage()));
                                    },
                                    icon: SvgPicture.asset(
                                        'lib/icons/settings.svg')),
                              ],
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            //inventory Summary
                            const Row(
                              children: [
                                Text(
                                  'Inventory Summary',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                  textScaleFactor: 1.2,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: ContainerHomeInventory(
                                    title: 'Available Stock',
                                    amount: instock.toString(),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: ContainerHomeInventory(
                                    title: 'To be Recieved',
                                    amount: toRecieve.toString(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 32,
                        ),
                        //activity portion
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Trading Activity',
                              style: TextStyle(fontWeight: FontWeight.w500),
                              textScaleFactor: 1.2,
                            ),
                            SizedBox(
                              height: 18.0,
                            ),
                            ContainerHomeActivity(
                              amt: '0',
                              title: 'To Be Shipped',
                              widget: AllHomeActivity(
                                currentIndex: 0,
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            ContainerHomeActivity(
                              amt: '0',
                              title: 'To Be Recieved',
                              widget: AllHomeActivity(
                                currentIndex: 1,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        //more portion
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' More',
                              style: TextStyle(fontWeight: FontWeight.w500),
                              textScaleFactor: 1.2,
                            ),
                            SizedBox(
                              height: 24.0,
                            ),
                            ContainerHomeMore(
                              title: 'Add new items',
                              type: 0,
                              action: AddItems(),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            ContainerHomeMore(
                              title: 'Add new costumer',
                              type: 1,
                              action: AddCustomer(),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            ContainerHomeMore(
                              title: 'Add new vendor',
                              type: 1,
                              action: AddVendor(),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            ContainerHomeMore(
                              title: 'More',
                              type: 2,
                              action: MoreFromHomePage(),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
            // if (isLoading) const LoadingOverlayHome()
          ],
        ),
      );
    });
  }
}

// ignore: camel_case_types
enum inventoryFilter {
  daily,
  weekly,
  monthly,
  yearly,
}
