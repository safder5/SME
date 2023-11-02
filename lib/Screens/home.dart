import 'package:ashwani/Screens/home/activity_home.dart';
import 'package:ashwani/Screens/more.dart';
import 'package:ashwani/Screens/settings/setting_page.dart';
import 'package:ashwani/Services/helper.dart';
import 'package:ashwani/Utils/Vendors/add_vendors.dart';
import 'package:ashwani/constantWidgets/boxes.dart';
import 'package:ashwani/Utils/customers/add_customer.dart';
import 'package:ashwani/Utils/items/add_items.dart';
import 'package:ashwani/Providers/inventory_summary_provider.dart';
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
  bool isLoading = true;
  bool isDisposed = false;
  bool hasData = false;

  final _auth = FirebaseAuth.instance.currentUser;
  Future<void> getRequiredHomeData() async {
    final inventorySummaryProvider =
        Provider.of<InventorySummaryProvider>(context, listen: false);
    await inventorySummaryProvider.totalInHand();
    await inventorySummaryProvider.totalTobeRecieved();
    if (!isDisposed) {
      setState(() {
        totalInHand = inventorySummaryProvider.inHand;
        totaltobeRecieved = inventorySummaryProvider.toRecieve;
        isLoading = false;
      });
    }
  }

  checkforProviderData() {
    final inventorySummaryProvider =
        Provider.of<InventorySummaryProvider>(context, listen: false);
    if (inventorySummaryProvider.inHand != 0 ||
        inventorySummaryProvider.toRecieve != 0) {
      if (!isDisposed) {
        setState(() {
          hasData = true;
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkforProviderData();
    getRequiredHomeData();
  }

  @override
  Widget build(BuildContext context) {
    final inventorySummaryProvider =
        Provider.of<InventorySummaryProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
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
                            Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingsPage()));
                          },
                          icon: SvgPicture.asset('lib/icons/settings.svg')),
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
                      ContainerHomeInventory(
                        title: 'Available Stock',
                        amount: inventorySummaryProvider.inHand.toString(),
                      ),
                      ContainerHomeInventory(
                        title: 'To be Recieved',
                        amount: inventorySummaryProvider.toRecieve.toString(),
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
                      SizedBox(
                        height: 15,
                      ),
                      ContainerHomeActivity(
                        amt: '0',
                        title: 'Quantity to be Shipped',
                       
                        widget: AllHomeActivity(
                          currentIndex: 1,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ContainerHomeActivity(
                        amt: '0',
                        title: 'Quantity to be Delivered',
                       
                        widget: AllHomeActivity(
                          currentIndex: 2,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  //more portion
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        title: 'Add new vendor',
                        type: 1,
                        action: AddVendor(),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ContainerHomeMore(
                        title: 'More',
                        type: 2,
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
            if (isLoading) const LoadingOverlayHome()
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types
enum inventoryFilter {
  daily,
  weekly,
  monthly,
  yearly,
}
