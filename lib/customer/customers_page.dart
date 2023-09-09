import 'package:ashwani/constantWidgets/boxes.dart';
import 'package:ashwani/constants.dart';
import 'package:ashwani/customer/add_customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final _auth = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const AddCustomer()));
        },
        backgroundColor: blue,
        child: const Center( child: Icon(LineIcons.plus,),),
      ),
      backgroundColor: w,
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
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('UserData')
                        .doc('${_auth!.email}')
                        .collection('Customers')
                        .snapshots(),
                    builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      final userCustomerSnapshot = snapshot.data?.docs;
                      if (userCustomerSnapshot!.isEmpty) {
                        return const Center(
                          child: Text('No Customers yet, Add Below '),
                        );
                      }
                      return ListView.builder(
                          itemCount: userCustomerSnapshot.length,
                          itemBuilder: (context, index) {
                            return CustomersPageContainer(
                                fullname: userCustomerSnapshot[index]
                                    ['fullName'],
                                companyname: userCustomerSnapshot[index]
                                    ['companyName']);
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