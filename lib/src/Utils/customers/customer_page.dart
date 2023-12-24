import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../Models/sales_order.dart';
import '../../Providers/customer_provider.dart';
import '../../Providers/new_sales_order_provider.dart';
import '../../Screens/sales/sales_order_page.dart';
import '../../constantWidgets/boxes.dart';
import '../../constants.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key, required this.customerName});
  final String customerName;

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  List<bool> isSelected = [true, false];
  List<String> toggleButtons = [
    ('Details'),
    ('Transactions'),
  ];
  List<SalesOrderModel> salesOrders = [];
  void getAllSalesOrdersOfthisCustomer() {
    final prov = Provider.of<NSOrderProvider>(context, listen: false);
    final orders = prov.som;
    final soc = orders
        .where((element) => element.customerName == widget.customerName)
        .toList();
    setState(() {
      salesOrders = soc;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllSalesOrdersOfthisCustomer();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerProvider>(builder: (_, prov, __) {
      final customers = prov.customers;
      final customer = customers
          .firstWhere((element) => element.name == widget.customerName);
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
                            'Customer Details',
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
                                  customer.name ?? '',
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
              CustomerDetails(
                phone: customer.phone ?? 'Not Available',
                mail: customer.email ?? 'Not Available',
              ),
            if (isSelected[1])
              CustomerTransactions(
                salesOrdersofthisCustomer: salesOrders,
              ),
          ],
        ),
      );
    });
  }
}

class CustomerDetails extends StatelessWidget {
  const CustomerDetails({super.key, required this.phone, required this.mail});
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

class CustomerTransactions extends StatefulWidget {
  const CustomerTransactions(
      {super.key, required this.salesOrdersofthisCustomer});
  final List<SalesOrderModel> salesOrdersofthisCustomer;
  @override
  State<CustomerTransactions> createState() => _CustomerTransactionsState();
}

class _CustomerTransactionsState extends State<CustomerTransactions> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: widget.salesOrdersofthisCustomer.length,
          itemBuilder: (context, index) {
            final salesOrder = widget.salesOrdersofthisCustomer[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true)
                    .push(MaterialPageRoute(
                        builder: (context) => SalesOrderPage(
                              orderId: salesOrder.orderID?? 0,
                            )));
              },
              child: ContainerSalesOrder(
                  orderID: salesOrder.orderID.toString(),
                  name: salesOrder.customerName!,
                  date: salesOrder.shipmentDate!,
                  status: salesOrder.status!),
            );
          }),
    );
  }
}
