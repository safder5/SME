import 'package:ashwani/Providers/vendor_provider.dart';
import 'package:ashwani/Utils/Vendors/add_vendors.dart';
import 'package:ashwani/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../constantWidgets/boxes.dart';

class VendorPage extends StatelessWidget {
  const VendorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance.currentUser;
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
              const SizedBox(
                height: 32,
              ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height,
              //   child: StreamBuilder<QuerySnapshot>(
              //       stream: FirebaseFirestore.instance
              //           .collection('UserData')
              //           .doc('${_auth!.email}')
              //           .collection('Vendors')
              //           .snapshots(),
              //       builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //         if (snapshot.connectionState == ConnectionState.waiting) {
              //           return CircularProgressIndicator(
              //             color: blue,
              //           );
              //         }
              //         final userCustomerSnapshot = snapshot.data?.docs;
              //         if (userCustomerSnapshot!.isEmpty) {
              //           return const Center(
              //             child: Text('No Customers yet, Add Below '),
              //           );
              //         }
              //         return ListView.builder(
              //             itemCount: userCustomerSnapshot.length,
              //             itemBuilder: (context, index) {
              //               return CustomersPageContainer(
              //                   fullname: userCustomerSnapshot[index]['name'],
              //                   companyname: userCustomerSnapshot[index]
              //                       ['companyName']);
              //             });
              //       })),
              // ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Consumer<VendorProvider>(
                    builder: ((context, provider, child) {
                  final vendors = provider.vendors;
                  return ListView.builder(
                      itemCount: vendors.length,
                      itemBuilder: (context, index) {
                        return CustomersPageContainer(
                            fullname: vendors[index].name?? ' ',
                            companyname: vendors[index].companyName?? ' '
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
