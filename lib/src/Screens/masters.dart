import 'package:ashwani/src/Screens/bom/bom_screen.dart';
import 'package:flutter/material.dart';

import '../Utils/Vendors/vendors_page.dart';
import '../Utils/customers/customers_page.dart';
import '../Utils/items/items_page.dart';
import '../constantWidgets/boxes.dart';

class Masters extends StatelessWidget {
  const Masters({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ' Masters ',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        SizedBox(
          height: 24.0,
        ),
        ContainerHomeMore(
          title: 'Items',
          type: 3,
          action: ItemsPage(),
        ),
        SizedBox(
          height: 10,
        ),
        ContainerHomeMore(
          title: 'Customers',
          type: 2,
          action: CustomersPage(),
        ),
        SizedBox(
          height: 10,
        ),
        ContainerHomeMore(
          title: 'Vendors',
          type: 4,
          action: VendorsPage(),
        ),
        SizedBox(
          height: 10,
        ),
        ContainerHomeMore(
          title: 'BOM',
          type: 4,
          action: BomScreen(),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
