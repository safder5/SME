import 'package:ashwani/constants.dart';
import 'package:ashwani/Utils/customers/add_customer.dart';
import 'package:ashwani/Utils/customers/customers_page.dart';
import 'package:ashwani/Utils/items/addItems.dart';
import 'package:ashwani/Utils/items/items_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:line_icons/line_icons.dart';

import '../Utils/Vendors/vendor.dart';
import '../constantWidgets/boxes.dart';

class MoreFromHomePage extends StatelessWidget {
  const MoreFromHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: w,
      body: SafeArea(child: Padding(
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
                  const Text('Add Item'),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 16,),
              const ContainerHomeMore(
                    title: 'Items',
                    type: 0,
                    action: ItemsPage(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const ContainerHomeMore(
                    title: 'Customers',
                    type: 1,
                    action: CustomerPage(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const ContainerHomeMore(
                    title: 'Vendors',
                    type: 1,
                    action: VendorPage(),
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