import 'package:ashwani/Providers/customer_provider.dart';
import 'package:ashwani/constantWidgets/boxes.dart';
import 'package:ashwani/constants.dart';
import 'package:ashwani/Utils/customers/add_customer.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import 'customer_page.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddCustomer()));
        },
        backgroundColor: blue,
        child: const Center(
          child: Icon(
            LineIcons.plus,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  const Text('Customers'),
                  const Spacer(),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              Consumer<CustomerProvider>(builder: (context, customerP, child) {
                final customers = customerP.customers;
                // print(customers.length);
                if (customers.isEmpty) {
                  return const Center(
                    child: Text('No Customers yet, Add Below '),
                  );
                }
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                      itemCount: customers.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => CustomerPage(customerName: customers[index].name?? ''))));
                          },
                          child: CustomersPageContainer(
                              fullname: customers[index].name!,
                              companyname: customers[index].companyName!),
                        );
                      }),
                );
              })
            ],
          ),
        ),
      )),
    );
  }
}


// SizedBox(
              //   height: MediaQuery.of(context).size.height,
              //   child: StreamBuilder<QuerySnapshot>(
              //       stream: FirebaseFirestore.instance
              //           .collection('UserData')
              //           .doc('${_auth!.email}')
              //           .collection('Customers')
              //           .snapshots(),
              //       builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //         if (snapshot.connectionState == ConnectionState.waiting) {
              //           return const CircularProgressIndicator();
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