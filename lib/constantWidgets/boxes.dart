import 'package:ashwani/constants.dart';
import 'package:ashwani/Providers/iq_list_provider.dart';
import 'package:flutter/material.dart';
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
          color: const Color(0xFFF7F7F7)),
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
                  style: const TextStyle(fontWeight: FontWeight.w300),
                  textScaleFactor: 0.8,
                ),
              ],
            ),
            const Spacer(),
            Text(
              widget.amount,
              style: const TextStyle(fontWeight: FontWeight.w600),
              textScaleFactor: 1.2,
            )
          ],
        ),
      ),
    );
  }
}

class ContainerHomeActivity extends StatefulWidget {
  const ContainerHomeActivity(
      {super.key, required this.amt, required this.title, required this.type});
  final String amt;
  final String title;
  final int type;
  @override
  State<ContainerHomeActivity> createState() => _ContainerHomeActivityState();
}

class _ContainerHomeActivityState extends State<ContainerHomeActivity> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66.0,
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
                backgroundColor: w,
                child: widget.type == 0
                    ? Icon(
                        LineIcons.box,
                        color: blue,
                      )
                    : widget.type == 1
                        ? Icon(LineIcons.truck, color: blue)
                        : Icon(LineIcons.truckLoading, color: blue)),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.amt,
                  style: const TextStyle(),
                  textScaleFactor: 1.2,
                ),
                Text(
                  widget.title,
                  style: const TextStyle(fontWeight: FontWeight.w200),
                  textScaleFactor: 0.8,
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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true)
            .push(MaterialPageRoute(builder: (context) => action));
      },
      child: Container(
        height: 66.0,
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                  backgroundColor: w,
                  child: type == 0
                      ? Icon(
                          LineIcons.addToShoppingCart,
                          color: blue,
                        )
                      : Icon(LineIcons.peopleCarry, color: blue)),
              const SizedBox(
                width: 15,
              ),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w300),
                textScaleFactor: 1.2,
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

class ContainerSalesOrder extends StatefulWidget {
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
  State<ContainerSalesOrder> createState() => _ContainerSalesOrderState();
}

class _ContainerSalesOrderState extends State<ContainerSalesOrder> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 160.0,
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: f7.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10)),
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
                    '#${widget.orderID}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    textScaleFactor: 0.9,
                  ),
                  const Spacer(),
                  // Text(
                  //   'Unit : 30 box',
                  //   style: TextStyle(
                  //       fontWeight: FontWeight.w400, color: b.withOpacity(0.5)),
                  //   textScaleFactor: 0.8,
                  // )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: b.withOpacity(0.5)),
                    textScaleFactor: 0.8,
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    widget.date,
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: b.withOpacity(0.5)),
                    textScaleFactor: 0.8,
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              //Triple Rows Start Here
              const Padding(
                padding:  EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    Icon(
                      LineIcons.box,
                      size: 18,
                    ),
                    // Spacer(),
                    Icon(
                      LineIcons.shoppingCart,
                      size: 18,
                    ),
                    // Spacer(),
                    Icon(
                      LineIcons.truck,
                      size: 18,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Stack(
                      children: [
                        Container(
                          height: 1,
                          width: width - 68.0,
                          color: d9,
                        ),
                        Container(
                          height: 1,
                          width: (width - 68.0) / 2,
                          color: gn,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Packed',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: b.withOpacity(0.82)),
                          textScaleFactor: 0.8,
                        ),
                        Text(
                          '20 Oct 2023',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: b.withOpacity(0.7)),
                          textScaleFactor: 0.5,
                        ),
                      ],
                    ),
                    // Spacer(),
                    Column(
                      children: [
                        Text(
                          'Shipped',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: b.withOpacity(0.82)),
                          textScaleFactor: 0.8,
                        ),
                        Text(
                          '25 Oct 2023',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: b.withOpacity(0.7)),
                          textScaleFactor: 0.5,
                        ),
                      ],
                    ),
                    // Spacer(),
                    Column(
                      children: [
                        Text(
                          'Delivered',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: b.withOpacity(0.82)),
                          textScaleFactor: 0.8,
                        ),
                        Text(
                          'Processing',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: b.withOpacity(0.7)),
                          textScaleFactor: 0.5,
                        ),
                      ],
                    ),
                  ],
                ),
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
      {super.key, required this.itemName, required this.sku});
  final String itemName;
  final String sku;
  //to add - units availableand image url loading
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration:
              BoxDecoration(color: f7, borderRadius: BorderRadius.circular(10)),
          height: 85,
          width: double.infinity,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 19.0, vertical: 21.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: blue,
                ),
                const SizedBox(
                  width: 20,
                ),
                //space
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      itemName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      textScaleFactor: 1.2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      sku,
                      textScaleFactor: 0.8,
                    )
                  ],
                ),
                const Spacer(),
                // space
                const Text(
                  'Unit: xx Box',
                  textScaleFactor: 1,
                  style: TextStyle(fontWeight: FontWeight.w300),
                )
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
              BoxDecoration(color: f7, borderRadius: BorderRadius.circular(10)),
          height: 85,
          width: double.infinity,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 19.0, vertical: 21.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: blue,
                ),
                const SizedBox(
                  width: 20,
                ),
                //space
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.companyname,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      textScaleFactor: 1.2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.fullname,
                      textScaleFactor: 0.8,
                    )
                  ],
                ),
                const Spacer(),
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
                    textScaleFactor: 0.8,
                    style: TextStyle(
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

class SOPDetailsItemTile extends StatelessWidget {
  final String name;
  final String quantity;
  final int index;
  const SOPDetailsItemTile(
      {super.key,
      required this.name,
      required this.quantity,
      required this.index});

  @override
  Widget build(BuildContext context) {
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
                    textScaleFactor: 0.8,
                    style: TextStyle(
                        color: b.withOpacity(0.5), fontWeight: FontWeight.w300),
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
