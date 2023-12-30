import 'package:ashwani/src/Models/user_model.dart';
import 'package:ashwani/src/Providers/iq_list_provider.dart';
import 'package:ashwani/src/Providers/new_purchase_order_provider.dart';
import 'package:ashwani/src/Providers/user_provider.dart';
import 'package:ashwani/src/Screens/home/activity_home.dart';
import 'package:ashwani/src/Screens/more.dart';
import 'package:ashwani/src/Screens/settings/setting_page.dart';
import 'package:ashwani/src/Utils/Vendors/add_vendors.dart';
import 'package:ashwani/src/constantWidgets/boxes.dart';
import 'package:ashwani/src/Utils/customers/add_customer.dart';
import 'package:ashwani/src/Utils/items/add_items.dart';
import 'package:ashwani/src/constants.dart';
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

  // final _auth = FirebaseAuth.instance.currentUser;

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

  // void getInvSummValues() {
  //   final p = Provider.of<InventorySummaryProvider>(context, listen: false);
  //   p.totalToBeRecieved();
  //   totaltobeRecieved = p.toRecieve;
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   // getInvSummValues();
  // }

  @override
  Widget build(BuildContext context) {
    final userP = Provider.of<UserProvider>(context, listen: false);
    final UserModel user = userP.user[0];
    return Consumer2<NPOrderProvider, ItemsProvider>(
        builder: (_, prov, pvdr, __) {
      pvdr.calculateStockInHand();
      final sih = pvdr.sih;
      prov.totalToBeRecieved();
      final totaltoRecieve = prov.toRecieve;
      // prov.totalToBeRecieved();
      // totaltobeRecieved = prov.toRecieve;
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
                                CircleAvatar(
                                  backgroundColor: b32,
                                  maxRadius: 20,
                                  child: ClipOval(
                                    child: Image(
                                      width: 40,
                                      height: 40,
                                      image: NetworkImage(user.photo),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.companyName,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      user.name,
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                // IconButton(
                                //     onPressed: () {
                                //       ProviderManager manage =
                                //           ProviderManager();
                                //       manage.resetAll();
                                //     },
                                //     icon: Icon(LineIcons.search)),
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
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
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
                                    amount: sih.toString(),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: ContainerHomeInventory(
                                    title: 'To be Recieved',
                                    amount: totaltoRecieve.toString(),
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
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14),
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
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14),
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
