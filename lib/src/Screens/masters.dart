import 'package:ashwani/src/Screens/bom/bom_screen.dart';
import 'package:flutter/material.dart';

import '../Utils/Vendors/vendors_page.dart';
import '../Utils/customers/customers_page.dart';
import '../Utils/items/items_page.dart';
import '../constantWidgets/boxes.dart'; 

class Masters extends StatefulWidget {
  const Masters({super.key});

  @override
  State<Masters> createState() => _MastersState();
}

class _MastersState extends State<Masters> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      //   title:  Center(
      //   child: const Text(
      //           ' Masters',
      //           style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      //         ),
      // ),),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 10),
              Text('Master'),
              SizedBox(
                height: 32,
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
          ),
        ),
      ),
    );
  }
}
