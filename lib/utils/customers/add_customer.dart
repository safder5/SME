import 'package:ashwani/Utils/customers/customers_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../constants.dart';
import '../../Services/helper.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({super.key});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final _auth = FirebaseAuth.instance.currentUser;
  final _fs = FirebaseFirestore.instance;

  String firstName = '';
  String lastName = '';
  String fullName = '';
  String companyName = '';
  String displayName = '';
  String email = '';
  String phoneNumber = '';
  String remarks = '';
  String type = 'business';

  bool _business = true;

  void shiftSelectiontobusiness() {
    if (_business != true) {
      setState(() => {
            _business = true,
            type = 'business'
          });
    }
  }

  void shiftSelectiontoindividual() {
    if (_business == true) {
      setState(() => {
            _business = false,
            type = 'individual'
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: w,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 32.0, left: 16.0, right: 16.0),
        child: GestureDetector(
          onTap: () async {
            //submit everything after validation is processed
            await _fs
                .collection('UserData')
                .doc('${_auth!.email}')
                .collection('Customers')
                .doc(fullName)
                .set({
              'fullName': fullName,
              'companyName': companyName,
              'displayName': displayName,
              'email': email,
              'phoneNumber': phoneNumber,
              'remarks': remarks,
              'type':type
            });
            setState(() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CustomerPage()));
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: blue,
            ),
            width: double.infinity,
            height: 48,
            child: Center(
                child: Text(
              'Add as Customer',
              style: TextStyle(
                color: w,
              ),
              textScaleFactor: 1.2,
            )),
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(LineIcons.angleLeft)),
                  const SizedBox(width: 10),
                  const Text('Add Customer'),
                  const Spacer(),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              const Text(
                'Customer Name',
                style: TextStyle(fontWeight: FontWeight.w300),
                textScaleFactor: 1,
              ),
              const SizedBox(
                height: 28,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        shiftSelectiontobusiness();
                      });
                    },
                    child: AbsorbPointer(
                      child: Row(
                        children: [
                          Container(
                            height: 14,
                            width: 14,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: w,
                                border: Border.all(
                                    width: 1, color: _business ? blue : b32)),
                            child: Center(
                              child: CircleAvatar(
                                maxRadius: 5,
                                backgroundColor: _business ? blue : w,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Business',
                            style: TextStyle(
                                fontWeight: FontWeight.w300, color: b),
                            textScaleFactor: 1.2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        shiftSelectiontoindividual();
                      });
                    },
                    child: AbsorbPointer(
                      child: Row(
                        children: [
                          Container(
                            height: 14,
                            width: 14,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: w,
                                border: Border.all(
                                    width: 1, color: _business ? b32 : blue)),
                            child: Center(
                              child: CircleAvatar(
                                maxRadius: 5,
                                backgroundColor: _business ? w : blue,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Individual',
                            style: TextStyle(
                                fontWeight: FontWeight.w300, color: b),
                            textScaleFactor: 1.2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // toggle ends here
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextFormField(
                    onChanged: (value) {
                      firstName = value;
                      fullName = '$value $lastName';
                    },
                    cursorWidth: 1,
                    cursorColor: blue,
                    validator: validateName,
                    decoration: getInputDecoration(
                            hint: 'First Name', errorColor: Colors.red)
                        .copyWith(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.45)),
                  ),
                  TextFormField(
                    onChanged: (value) {
                      lastName = value;
                      fullName = '$firstName $value';
                      // print(fullName);
                    },
                    cursorColor: blue,
                    cursorWidth: 1,
                    validator: validateName,
                    decoration: getInputDecoration(
                            hint: 'Last Name', errorColor: Colors.red)
                        .copyWith(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.45)),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                onChanged: (value) {
                  companyName = value;
                },
                cursorWidth: 1,
                cursorColor: blue,
                validator: validateName,
                decoration: getInputDecoration(
                    hint: 'Company Name', errorColor: Colors.red),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                onChanged: (value) {
                  displayName = value;
                },
                cursorWidth: 1,
                cursorColor: blue,
                validator: validateName,
                decoration: getInputDecoration(
                    hint: 'Display Name', errorColor: Colors.red),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                onChanged: (value) {
                  email = value;
                },
                cursorWidth: 1,
                cursorColor: blue,
                validator: validateName,
                decoration:
                    getInputDecoration(hint: 'Email', errorColor: Colors.red),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                onChanged: (value) {
                  phoneNumber = value;
                },
                cursorWidth: 1,
                cursorColor: blue,
                validator: validateOrderNo,
                decoration: getInputDecoration(
                    hint: 'Phone Number', errorColor: Colors.red),
              ),
              const SizedBox(
                height: 24,
              ),
              GestureDetector(
                onTap: () {
                  // add shipping and details somehow
                },
                child: GestureDetector(
                  onTap: () {
                    //add shipping details pop up menu here
                    //do it later
                    showModalBottomSheet<dynamic>(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                          );
                        });
                  },
                  child: AbsorbPointer(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.transparent,
                          border: Border.all(width: 0.6, color: blue)),
                      width: double.infinity,
                      height: 48,
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LineIcons.plusCircle,
                            color: blue,
                          ),
                          Text(
                            '  Add Billing & Shipping Address',
                            style: TextStyle(
                                color: blue, fontWeight: FontWeight.w300),
                            textScaleFactor: 1,
                          ),
                        ],
                      )),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                onChanged: (value) {
                  remarks = value;
                },
                cursorWidth: 1,
                cursorColor: blue,
                // validator: validateName,
                decoration: getInputDecoration(
                    hint: 'Remarks (personal) ', errorColor: Colors.red),
              ),
              // const SizedBox(
              //   height: 24,
              // ),
            ],
          ),
        ),
      )),
    );
  }
}
