import 'package:ashwani/Models/purchase_order.dart';
import 'package:ashwani/Providers/new_purchase_order_provider.dart';
import 'package:ashwani/Providers/vendor_provider.dart';
import 'package:ashwani/Screens/purchase/purchase_order_page.dart';
import 'package:ashwani/constantWidgets/boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class VendorPage extends StatefulWidget {
  const VendorPage({super.key, required this.vendorName});
  final String vendorName;

  @override
  State<VendorPage> createState() => _VendorPageState();
}

class _VendorPageState extends State<VendorPage> {
  List<bool> isSelected = [true, false];
  List<String> toggleButtons = [
    ('Details'),
    ('Transactions'),
  ];
  List<PurchaseOrderModel> purchaseOrders = [];
  void getVendorPurchases() {
    final prov = Provider.of<NPOrderProvider>(context, listen: false);
    final order = prov.po;
    final pov = order
        .where((element) => element.vendorName == widget.vendorName)
        .toList();
    setState(() {
      purchaseOrders = pov;
    });
  }

  @override
  void initState() {
    super.initState();
    getVendorPurchases();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VendorProvider>(builder: (_, prov, __) {
      final vendors = prov.vendors;
      final vendor =
          vendors.firstWhere((element) => element.name == widget.vendorName);
      return Scaffold(
        backgroundColor: w,
        // not in scroll view dumbass
        body: Column(
          children: [
            Container(
              // height: MediaQuery.of(context).size.height / 3,
              color: blue,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                LineIcons.angleLeft,
                                color: w,
                              )),
                          const SizedBox(width: 10),
                          Text(
                            'Vendor Details',
                            style: TextStyle(color: w, fontSize: 14),
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vendor.name ?? '',
                                  style: TextStyle(
                                      color: w,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                // Text(
                                //   'SIH: ${customer.itemQuantity}',
                                //   style: TextStyle(
                                //       color: w, fontWeight: FontWeight.w300),
                                //   textScaleFactor: 1,
                                // ),
                              ],
                            ),
                            const Spacer(),
                            SvgPicture.asset('lib/icons/attatchment.svg')
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              // height: MediaQuery.of(context).size.height * 0.66,
              color: w,
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      for (var i = 0; i < isSelected.length; i++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              for (var buttonIndex = 0;
                                  buttonIndex < isSelected.length;
                                  buttonIndex++) {
                                if (buttonIndex == i) {
                                  isSelected[buttonIndex] = true;
                                } else {
                                  isSelected[buttonIndex] = false;
                                }
                              }
                            });
                          },
                          child: Container(
                            // margin: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                            height: 45,
                            width: MediaQuery.of(context).size.width * 0.45,
                            decoration: BoxDecoration(
                                color:
                                    isSelected[i] ? blue : b.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              toggleButtons[i],
                              style: TextStyle(
                                  color: isSelected[i] ? w : b,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14),
                            )),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected[0])
              VendorDetails(
                phone: vendor.phone ?? 'Not Available',
                mail: vendor.email ?? 'Not Available',
              ),
            if (isSelected[1])
              VendorTransactions(
                purchaseOrdersOfThisVendor: purchaseOrders,
              ),
          ],
        ),
      );
    });
  }
}

class VendorDetails extends StatelessWidget {
  const VendorDetails({super.key, required this.phone, required this.mail});
  final String phone;
  final String mail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            // height: 120,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: f7,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: w,
                      radius: 16,
                      child: SvgPicture.asset('lib/icons/contact.svg'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('Contact Details')
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SvgPicture.asset('lib/icons/phone.svg'),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(phone,
                        style: const TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 10))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SvgPicture.asset('lib/icons/mail.svg'),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(mail,
                        style: const TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 10))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VendorTransactions extends StatefulWidget {
  const VendorTransactions(
      {super.key, required this.purchaseOrdersOfThisVendor});
  final List<PurchaseOrderModel> purchaseOrdersOfThisVendor;
  @override
  State<VendorTransactions> createState() => _VendorTransactionsState();
}

class _VendorTransactionsState extends State<VendorTransactions> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: widget.purchaseOrdersOfThisVendor.length,
          itemBuilder: (context, index) {
            final purchaseOrder = widget.purchaseOrdersOfThisVendor[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true)
                    .push(MaterialPageRoute(
                        builder: (context) => PurchaseOrderPage(
                              orderId: purchaseOrder.orderID,
                            )));
              },
              child: ContainerPurchaseOrder(
                  orderID: purchaseOrder.orderID.toString(),
                  name: purchaseOrder.vendorName!,
                  date: purchaseOrder.deliveryDate!,
                  status: purchaseOrder.status!),
            );
          }),
    );
  }
}
