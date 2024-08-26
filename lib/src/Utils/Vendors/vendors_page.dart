import 'package:ashwani/src/Providers/vendor_provider.dart';
import 'package:ashwani/src/Utils/Vendors/add_vendors.dart';
import 'package:ashwani/src/Utils/Vendors/vendor_page.dart';
import 'package:ashwani/src/constants.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../constantWidgets/boxes.dart';

class VendorsPage extends StatefulWidget {
  const VendorsPage({super.key});

  @override
  State<VendorsPage> createState() => _VendorsPageState();
}

class _VendorsPageState extends State<VendorsPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // final _auth = FirebaseAuth.instance.currentUser;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: blue,
        heroTag: '/vendor',
        tooltip: 'Add Vendor',
        onPressed: (() {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => const AddVendor())));
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
              const SizedBox(
                height: 32,
              ),

              // Add the search bar here
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search vendors...',
                  suffixIcon: Icon(LineIcons.search),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0.5),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Consumer<VendorProvider>(
                    builder: ((context, provider, child) {
                  final vendors = provider.vendors
                      .where((vendor) =>
                          vendor.name.toLowerCase().contains(_searchQuery))
                      .toList()
                      .reversed
                      .toList();
                  return ListView.builder(
                      itemCount: vendors.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VendorPage(
                                          vendorName: vendors[index].name,
                                        )));
                          },
                          child: VendorsPageContainer(
                            fullname: vendors[index].name,
                          ),
                        );
                      });
                })),
              )
            ],
          ),
        ),
      )),
    );
  }
}
