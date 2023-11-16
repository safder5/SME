import 'package:ashwani/constants.dart';
import 'package:ashwani/Utils/customers/customers_page.dart';
import 'package:ashwani/Utils/items/items_page.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../Utils/Vendors/vendors_page.dart';
import '../constantWidgets/boxes.dart';

class MoreFromHomePage extends StatelessWidget {
  const MoreFromHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(LineIcons.angleLeft)),
                const SizedBox(width: 10),
                const Text('More'),
                const Spacer(),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            const ContainerHomeMore(
              title: 'Items',
              type: 3,
              action: ItemsPage(),
            ),
            const SizedBox(
              height: 15,
            ),
            const ContainerHomeMore(
              title: 'Customers',
              type: 2,
              action: CustomersPage(),
            ),
            const SizedBox(
              height: 15,
            ),
            const ContainerHomeMore(
              title: 'Vendors',
              type: 4,
              action: VendorsPage(),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      )),
    );
  }
}
