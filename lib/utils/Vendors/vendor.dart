import 'package:ashwani/Utils/Vendors/add_vendors.dart';
import 'package:ashwani/constants.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class VendorPage extends StatelessWidget {
  const VendorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: blue,
        heroTag: '/vendor',
        tooltip: 'Add Vendor',
        onPressed: (() {
          Navigator.push(
              context, MaterialPageRoute(builder: ((context) => AddVendor())));
        }),
        child: Icon(
          LineIcons.plus,
          color: w,
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
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
                  const Text('Vendors'),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
