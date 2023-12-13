import 'package:ashwani/src/Models/bom_model.dart';
import 'package:ashwani/src/Models/iq_list.dart';
import 'package:ashwani/src/Models/production_model.dart';
import 'package:ashwani/src/Providers/bom_providers.dart';
import 'package:ashwani/src/constants.dart';
import 'package:ashwani/src/Providers/iq_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class ContainerHomeInventory extends StatefulWidget {
  const ContainerHomeInventory(
      {super.key, required this.title, required this.amount});
  final String title;
  final String amount;
  @override
  State<ContainerHomeInventory> createState() => _ContainerHomeInventoryState();
}

class _ContainerHomeInventoryState extends State<ContainerHomeInventory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66.0,
      width: MediaQuery.of(context).size.width / 2.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: blue,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  widget.title,
                  style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 10),
                ),
              ],
            ),
            const Spacer(),
            Text(
              widget.amount,
              style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}

class ContainerSettings extends StatelessWidget {
  const ContainerSettings(
      {super.key, required this.title, required this.widget});
  final String title;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => widget));
      },
      child: Container(
        height: 53.0,
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: b.withOpacity(0.6)),
              ),
              const Spacer(),
              CircleAvatar(
                maxRadius: 10,
                backgroundColor: w,
                child: Center(
                  child: Icon(
                    LineIcons.angleRight,
                    color: b32,
                    size: 14,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ContainerHomeActivity extends StatefulWidget {
  const ContainerHomeActivity(
      {super.key,
      required this.amt,
      required this.title,
      required this.widget});
  final String amt;
  final String title;
  final Widget widget;
  @override
  State<ContainerHomeActivity> createState() => _ContainerHomeActivityState();
}

class _ContainerHomeActivityState extends State<ContainerHomeActivity> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => widget.widget));
      },
      child: Container(
        height: 76.0,
        width: double.maxFinite,
        decoration:
            BoxDecoration(color: w, borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: widget.title == 'To Be Shipped'
                      ? SvgPicture.asset('lib/icons/truck.svg')
                      : SvgPicture.asset('lib/icons/shoping.svg')),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(
                  //   widget.amt,
                  //   style: const TextStyle(),
                  //   textScaleFactor: 1.2,
                  // ),
                  Text(
                    widget.title,
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  )
                ],
              ),
              const Spacer(),
              CircleAvatar(
                maxRadius: 10,
                backgroundColor: w,
                child: Center(
                  child: Icon(
                    LineIcons.angleRight,
                    color: b32,
                    size: 14,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ContainerHomeMore extends StatelessWidget {
  const ContainerHomeMore(
      {super.key,
      required this.title,
      required this.type,
      required this.action});
  final String title;
  final int type;
  final Widget action;
  Widget iconselect(int t) {
    String name;
    switch (t) {
      case 0:
        name = 'add_items';
        break;
      case 1:
        name = 'add_customer';
        break;
      case 2:
        name = 'more';
        break;
      case 3:
        name = 'items';
        break;
      case 4:
        name = 'vendors';
        break;
      // case 5:
      // name = 'settings';
      // break;
      default:
        name = 'more';
    }
    return SvgPicture.asset('lib/icons/$name.svg');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true)
            .push(MaterialPageRoute(builder: (context) => action));
      },
      child: Container(
        height: 71.0,
        width: double.maxFinite,
        decoration:
            BoxDecoration(color: w, borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: iconselect(type)),
              const SizedBox(
                width: 15,
              ),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 14),
              ),
              const Spacer(),
              CircleAvatar(
                maxRadius: 10,
                backgroundColor: w,
                child: Center(
                  child: Icon(
                    LineIcons.angleRight,
                    color: b32,
                    size: 14,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ContainerSalesOrder extends StatelessWidget {
  const ContainerSalesOrder(
      {super.key,
      required this.orderID,
      required this.name,
      required this.date,
      required this.status});
  final String orderID;
  final String name;
  final String date;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        width: double.maxFinite,
        decoration:
            BoxDecoration(color: w, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 8.0,
                    width: 8.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      color: blue,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '#$orderID',
                    // style: const TextStyle(fontWeight: FontWeight.w600),
                    // textScaleFactor: 0.9,
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text('Name: $name',
                      style: TextStyle(color: b.withOpacity(0.5),fontSize: 10)),
                  const Spacer(),
                  Text(
                    status == 'open'
                        ? 'Order Placed'.toUpperCase()
                        : 'Order Shipped'.toUpperCase(),
                    style: TextStyle(color: gn.withOpacity(0.8),fontSize: 12),
                  )
                ],
              ),
              Text(
                'Date: $date',
                style: TextStyle(color: b.withOpacity(0.5),fontSize: 10),
              ),
              // const SizedBox(
              //   height: 16,
              // ),
              //Triple Rows Start Here
            ],
          ),
        ),
      ),
    );
  }
}

class ContainerPurchaseReturn extends StatelessWidget {
  const ContainerPurchaseReturn(
      {super.key,
      required this.itemname,
      required this.orderId,
      required this.quantity});
  final String itemname;
  final int orderId;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 80.0,
        width: MediaQuery.of(context).size.width - 64,
        decoration:
            BoxDecoration(color: w, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 8.0,
                    width: 8.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      color: blue,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    '#$orderId',
                    style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 12),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemname,
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: b.withOpacity(0.5),fontSize: 10),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Container(
                    height: 12,
                    width: 1,
                    color: b32,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    'Units: $quantity',
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: b.withOpacity(0.5),fontSize: 10),
                  ),
                  const Spacer(),
                  // Text(
                  //   toInventory ? 'In Inventory' : 'Wasted',
                  //   style: TextStyle(
                  //       fontWeight: FontWeight.w300,
                  //       color: toInventory ? gn : r),
                  //   textScaleFactor: 0.8,
                  // )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContainerSalesReturn extends StatelessWidget {
  const ContainerSalesReturn({
    super.key,
    required this.itemname,
    required this.orderId,
    required this.quantity,
  });
  final String itemname;
  final int orderId;
  final int quantity;
  final bool toInventory = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 80.0,
        width: MediaQuery.of(context).size.width - 64,
        decoration:
            BoxDecoration(color: w, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 8.0,
                    width: 8.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      color: blue,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    '#$orderId',
                    style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 12),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemname,
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: b.withOpacity(0.5),fontSize: 10),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Container(
                    height: 12,
                    width: 1,
                    color: b32,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    'Units: $quantity',
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: b.withOpacity(0.5),fontSize: 10),
                  ),
                  const Spacer(),
                  Text(
                    toInventory ? 'In Inventory' : 'Wasted',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: toInventory ? gn : r,fontSize: 10),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContainerPurchaseOrder extends StatelessWidget {
  const ContainerPurchaseOrder(
      {super.key,
      required this.orderID,
      required this.name,
      required this.date,
      required this.status});
  final String orderID;
  final String name;
  final String date;
  final String status;

  @override
  Widget build(BuildContext context) {
    //  double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: double.maxFinite,
        decoration:
            BoxDecoration(color: w, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 8,
                    width: 8,
                    color: blue,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '#$orderID',
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text('Name: $name',
                      style: TextStyle(color: b.withOpacity(0.5),fontSize: 10)),
                  const Spacer(),
                  Text(
                    status.toUpperCase(),
                    style: TextStyle(color: gn.withOpacity(0.8),fontSize: 12),
                  )
                ],
              ),
              Text(
                'Date: $date',
                style: TextStyle(color: b.withOpacity(0.5),fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PurchaseActivityTile extends StatelessWidget {
  const PurchaseActivityTile({super.key, required this.activity});
  final ItemTrackingPurchaseOrder? activity;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.maxFinite,
        decoration:
            BoxDecoration(color: w, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 8,
                        width: 8,
                        color: blue,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(activity!.itemName,
                          style: TextStyle(color: b.withOpacity(0.8))),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    activity!.date!,
                    style: TextStyle(color: b.withOpacity(0.5),fontSize: 10),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    activity!.vendor!,
                    style: TextStyle(color: b.withOpacity(0.5),fontSize: 10),
                  ),
                ],
              ),
              const Spacer(),
              activity!.quantityRecieved == 0
                  ? Text(
                      activity!.quantityReturned.toString(),
                      style: TextStyle(
                          color: r.withOpacity(0.8),
                          fontWeight: FontWeight.w300,fontSize: 18),
                    )
                  : Text(
                      activity!.quantityRecieved.toString(),
                      style: TextStyle(
                          color: gn.withOpacity(0.8),
                          fontWeight: FontWeight.w300,fontSize: 18),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class SalesActivityTile extends StatelessWidget {
  const SalesActivityTile({super.key, this.activity});
  final ItemTrackingSalesOrder? activity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.maxFinite,
        decoration:
            BoxDecoration(color: w, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 8,
                        width: 8,
                        color: blue,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(activity!.itemName,
                          style: TextStyle(color: b.withOpacity(0.8))),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    activity!.date!,
                    style: TextStyle(color: b.withOpacity(0.5),fontSize: 10),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    activity!.customer!,
                    style: TextStyle(color: b.withOpacity(0.5), fontSize: 10),
                  ),
                ],
              ),
              const Spacer(),
              activity!.quantityReturned == 0
                  ? Text(
                      activity!.quantityShipped.toString(),
                      style: TextStyle(
                          color: r.withOpacity(0.8),
                          fontWeight: FontWeight.w300,
                          fontSize: 18),
                    )
                  : Text(
                      activity!.quantityReturned.toString(),
                      style: TextStyle(
                          color: gn.withOpacity(0.8),
                          fontWeight: FontWeight.w300,
                          fontSize: 18),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class ItemsPageContainer extends StatelessWidget {
  const ItemsPageContainer(
      {super.key,
      required this.itemName,
      required this.sku,
      required this.imgUrl, required this.unitType});
  final String itemName;
  final String sku;
  final String imgUrl;
  final String unitType;
  //to add - units availableand image url loading

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration:
              BoxDecoration(color: w, borderRadius: BorderRadius.circular(10)),
          // height: 92,
          width: double.infinity,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: w,
                    // border:
                    //     Border.all(width: 1, color: b32)),
                  ),
                  child: const Icon(LineIcons.box),
                ),
                const SizedBox(
                  width: 10,
                ),
                // CachedNetworkImage(imageUrl: imgUrl,),
                // const SizedBox(
                //   width: 20,
                // ),
                //space
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Item Name: $itemName',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    Text(
                      'Units Available: $sku $unitType',style: const TextStyle(fontSize: 10),
                    )
                  ],
                ),
                const Spacer(),
                // space
                // const Text(
                //   'Unit Type: ',
                //   textScaleFactor: 1,
                //   style: TextStyle(fontWeight: FontWeight.w300),
                // )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }
}

class BOMContainer extends StatelessWidget {
  const BOMContainer({super.key, required this.bom});
  final BOMmodel bom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        width: double.maxFinite,
        decoration:
            BoxDecoration(color: w, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 8.0,
                    width: 8.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      color: blue,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '#${bom.productCode ?? '0123'}',
                    // style: const TextStyle(fontWeight: FontWeight.w600),
                    // textScaleFactor: 0.9,
                  ),
                  const Spacer(),
                  Text(
                    'Total Items: ${bom.itemswithQuantities.length}',
                    style: TextStyle(color: b.withOpacity(0.5), fontSize: 10),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text('Product Name : ${bom.productName}',
                      style: TextStyle(color: b.withOpacity(0.5), fontSize: 10)),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductionContainer extends StatelessWidget {
  const ProductionContainer({super.key, required this.prod});
  final ProductionModel prod;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        width: double.maxFinite,
        decoration:
            BoxDecoration(color: w, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 8.0,
                    width: 8.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      color: blue,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '#${prod.productionID}',
                    // style: const TextStyle(fontWeight: FontWeight.w600),
                    // textScaleFactor: 0.9,
                  ),
                  const Spacer(),
                  Text(
                    ' Quantity Produced: ${prod.quantityofBOMProduced}',
                    style: TextStyle(color: b.withOpacity(0.5), fontSize: 10),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text('Product Name : ${prod.nameofBOM}',
                      style: TextStyle(color: b.withOpacity(0.5), fontSize: 10)),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomersPageContainer extends StatefulWidget {
  const CustomersPageContainer(
      {super.key, required this.fullname, required this.companyname});
  final String fullname;
  final String companyname;
  @override
  State<CustomersPageContainer> createState() => _CustomersPageContainerState();
}

class _CustomersPageContainerState extends State<CustomersPageContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration:
              BoxDecoration(color: w, borderRadius: BorderRadius.circular(5)),
          height: 92,
          width: double.infinity,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 19.0, vertical: 21.0),
            child: Row(
              children: [
                // CircleAvatar(
                //   backgroundColor: blue,
                // ),
                // const SizedBox(
                //   width: 20,
                // ),
                //space
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    //   widget.companyname,
                    //   style: const TextStyle(fontWeight: FontWeight.w600),
                    //   textScaleFactor: 1.2,
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    Text(
                      widget.fullname,
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Items to be shipped:  ',
                          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 10,
                          color: b25,
                          width: 1,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'Delivered Items:  ',
                          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }
}

class VendorsPageContainer extends StatelessWidget {
  const VendorsPageContainer({super.key, required this.fullname});
  final String fullname;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration:
              BoxDecoration(color: w, borderRadius: BorderRadius.circular(5)),
          height: 92,
          width: double.infinity,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 19.0, vertical: 21.0),
            child: Row(
              children: [
                // CircleAvatar(
                //   backgroundColor: blue,
                // ),
                // const SizedBox(
                //   width: 20,
                // ),
                //space
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    //   widget.companyname,
                    //   style: const TextStyle(fontWeight: FontWeight.w600),
                    //   textScaleFactor: 1.2,
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    Text(
                      fullname,
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Items to be shipped:  ',
                          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 10,
                          color: b25,
                          width: 1,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'Delivered Items:  ',
                          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10),
                        ),
                      ],
                    )
                  ],
                ),
                // const Spacer(),
                // space
                // const Text(
                //   '',
                //   textScaleFactor: 1,
                //   style: TextStyle(fontWeight: FontWeight.w300),
                // )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }
}

class NewBomOrderItemTile extends StatelessWidget {
  final String name;
  final String quantity;
  final int index;
  const NewBomOrderItemTile(
      {super.key,
      required this.name,
      required this.quantity,
      required this.index});

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<BOMProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Container(
        height: 66,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: f7.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14.0,
          ),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: w),
                child: const Icon(LineIcons.box),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                  Text(
                    'Units : ${quantity.toString()}',
                    style: TextStyle(fontSize: 10,
                        color: b.withOpacity(0.5), fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    itemProvider.removeItem(index);
                  },
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    size: 18,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class NewSalesOrderItemsTile extends StatelessWidget {
  final String name;
  final String quantity;
  final int index;
  const NewSalesOrderItemsTile(
      {super.key,
      required this.name,
      required this.quantity,
      required this.index});

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemsProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Container(
        height: 66,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: f7.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14.0,
          ),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: w),
                child: null,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                  Text(
                    'Units : ${quantity.toString()}',
                    style: TextStyle(
                        color: b.withOpacity(0.5), fontWeight: FontWeight.w300,
                        fontSize: 10),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    itemProvider.removesoItem(index);
                  },
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    size: 18,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class NewPurchaseOrderItemsTile extends StatelessWidget {
  final String name;
  final String quantity;
  final int index;
  const NewPurchaseOrderItemsTile(
      {super.key,
      required this.name,
      required this.quantity,
      required this.index});

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemsProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Container(
        height: 66,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: f7.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14.0,
          ),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: w),
                child: null,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                  Text(
                    'Units : ${quantity.toString()}',
                    style: TextStyle(
                        color: b.withOpacity(0.5), fontWeight: FontWeight.w300,
                        fontSize: 10),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    itemProvider.removepoItem(index);
                  },
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    size: 18,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class SOPDetailsItemTile extends StatelessWidget {
  final String name;
  final String quantity;
  final int index;
  final int original;
  const SOPDetailsItemTile(
      {super.key,
      required this.name,
      required this.quantity,
      required this.index,
      required this.original});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        height: 66,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: f7.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14.0,
          ),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: w),
                child: const Icon(LineIcons.box),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                  Row(
                    children: [
                      Text(
                        'Units : ${original.toString()}',
                        style: TextStyle(
                            color: b.withOpacity(0.5),
                            fontWeight: FontWeight.w300,
                            fontSize: 10),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 0.5, // Width of the vertical line
                        height:
                            12, // Height to fill the available vertical space
                        color: b32, // Color of the line
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'To Ship : ${quantity.toString()}',
                        style: TextStyle(
                            color: b.withOpacity(0.5),
                            fontWeight: FontWeight.w300,
                            fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class SOPShippedItemsTile extends StatelessWidget {
  final String quantity;
  final String itemName;
  final int index;
  final int? quantityReturned;
  const SOPShippedItemsTile(
      {super.key,
      required this.quantity,
      required this.itemName,
      required this.index,
      this.quantityReturned});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        height: 66,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: t, //f7.withOpacity(0.7)
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14.0,
          ),
          child: Row(
            children: [
              Container(
                width: 15,
                height: 15,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                child: SvgPicture.asset('lib/icons/tick.svg')
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemName,
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Row(
                    children: [
                      Text(
                        'Units : ${quantity.toString()}',
                        style: TextStyle(
                            color: b.withOpacity(0.5),
                            fontWeight: FontWeight.w300,
                            fontSize: 9),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 0.5, // Width of the vertical line
                        height:
                            12, // Height to fill the available vertical space
                        color: b32, // Color of the line
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        quantityReturned == 0
                            ? ''
                            : 'Returned: ${quantityReturned.toString()}',
                        style: TextStyle(
                            color: b.withOpacity(0.5),
                            fontWeight: FontWeight.w300,
                            fontSize: 9),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Text(
                'Delivered',
                style: TextStyle(color: gn, fontWeight: FontWeight.w300, fontSize: 10),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// class TickPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = Colors.white
//       ..strokeWidth = 0.5
//       ..style = PaintingStyle.stroke;

//     final double halfSize = size.width / 2;

//     final Path path = Path()
//       ..moveTo(halfSize - 5, halfSize)
//       ..lineTo(halfSize, halfSize + 5)
//       ..lineTo(halfSize + 7, halfSize - 7);

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }

class SOReturnsItemTile extends StatelessWidget {
  final String quantity;
  final String itemName;
  final int index;
  const SOReturnsItemTile(
      {super.key,
      required this.quantity,
      required this.itemName,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        height: 66,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: f7.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14.0,
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemName,
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Row(
                    children: [
                      Text(
                        'Units : ${quantity.toString()}',
                        style: TextStyle(
                            color: b.withOpacity(0.5),
                            fontWeight: FontWeight.w300,
                            fontSize: 9),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Text(
                'Returned',
                style: TextStyle(color: blue, fontWeight: FontWeight.w300, fontSize: 10),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PoDetailsItemTile extends StatelessWidget {
  const PoDetailsItemTile(
      {super.key,
      required this.name,
      required this.quantity,
      required this.index,
      required this.original});
  final String name;
  final String quantity;
  final int index;
  final int original;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        height: 66,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: f7.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14.0,
          ),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: w),
                child: const Icon(LineIcons.box),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                  Row(
                    children: [
                      Text(
                        'Units : ${original.toString()}',
                        style: TextStyle(
                            color: b.withOpacity(0.5),
                            fontWeight: FontWeight.w300 ,
                            fontSize: 10),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 0.5, // Width of the vertical line
                        height:
                            12, // Height to fill the available vertical space
                        color: b32, // Color of the line
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'To Recieve : ${quantity.toString()}',
                        style: TextStyle(
                            color: b.withOpacity(0.5),
                            fontWeight: FontWeight.w300,
                            fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class PORecievedItemTile extends StatelessWidget {
  final String quantity;
  final String itemName;
  final int index;
  final int? quantityReturned;
  const PORecievedItemTile(
      {super.key,
      required this.quantity,
      required this.itemName,
      required this.index,
      this.quantityReturned});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        height: 66,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: t,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14.0,
          ),
          child: Row(
            children: [
               Container(
                  width: 15,
                  height: 15,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: SvgPicture.asset('lib/icons/tick.svg')),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemName,
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Row(
                    children: [
                      Text(
                        'Units : $quantity',
                        style: TextStyle(
                            color: b.withOpacity(0.5),
                            fontWeight: FontWeight.w300,
                            fontSize: 9),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 0.5, // Width of the vertical line
                        height:
                            12, // Height to fill the available vertical space
                        color: b32, // Color of the line
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        quantityReturned == 0
                            ? ''
                            : 'Returned: ${quantityReturned.toString()}',
                        style: TextStyle(
                            color: b.withOpacity(0.5),
                            fontWeight: FontWeight.w300,
                            fontSize: 9),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Text(
                'Recieved',
                style: TextStyle(color: gn, fontWeight: FontWeight.w300, fontSize: 10),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class POReturnsTile extends StatelessWidget {
  final String itemName;
  final int index;
  final int? quantityReturned;
  const POReturnsTile(
      {super.key,
      required this.itemName,
      required this.index,
      this.quantityReturned});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        height: 66,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: f7.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14.0,
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemName,
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    quantityReturned == 0
                        ? ''
                        : 'Returned: ${quantityReturned.toString()}',
                    style: TextStyle(
                        color: b.withOpacity(0.5), fontWeight: FontWeight.w300,
                        fontSize: 9),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                'Returned',
                style: TextStyle(color: r, fontWeight: FontWeight.w300, fontSize: 10),
              )
            ],
          ),
        ),
      ),
    );
  }
}
