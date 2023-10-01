import 'package:ashwani/Providers/bs_address_provider.dart';
import 'package:ashwani/Providers/vendor_provider.dart';
import 'package:ashwani/Utils/addAddressBillingShipping.dart/add_address.dart';
import 'package:ashwani/constants.dart';
import 'package:ashwani/Models/address_model.dart';
import 'package:ashwani/Models/vendor_model.dart';
import 'package:ashwani/Services/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class AddVendor extends StatefulWidget {
  const AddVendor({super.key});

  @override
  State<AddVendor> createState() => _AddVendorState();
}

class _AddVendorState extends State<AddVendor> {
  final GlobalKey<FormState> addVendorForm = GlobalKey<FormState>();
  String? name, cName, dName, email, phone, remarks;
  AddressModel? bill, ship;
  TextEditingController nameController = TextEditingController();
  TextEditingController cnameController = TextEditingController();
  TextEditingController dnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  bool isAddressSaved = false;

  void setAddresSaved(bool saved) {
    setState(() {
      isAddressSaved = saved;
    });
  }

  @override
  Widget build(BuildContext context) {
    final addressPvr = Provider.of<BSAddressProvider>(context);
    final vendor_provider = Provider.of<VendorProvider>(context);
    final auth = FirebaseAuth.instance.currentUser;
    return Scaffold(
      // bottomNavigationBar: ,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 32.0, left: 16.0, right: 16.0),
        child: GestureDetector(
          onTap: () async {
            final docRef = FirebaseFirestore.instance
                .collection('UserData')
                .doc('${auth!.email}')
                .collection('Vendors')
                .doc(nameController.text);
            //submit everything after validation is processed

            final vendorData = VendorModel(
              name: nameController.text,
              displayName: dnameController.text,
              companyName: cnameController.text,
              email: emailController.text,
              phone: phoneController.text,
              remarks: remarksController.text,
            );
            if (addressPvr.shipping != null) {
              bill = addressPvr.billing;
              ship = addressPvr.shipping;
            }
            await vendor_provider.addVendor(vendorData, docRef, bill, ship);
            addressPvr.clearAddresses();
            Navigator.pop(context);
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
              'Add Vendor',
              style: TextStyle(
                color: w,
              ),
              textScaleFactor: 1.2,
            )),
          ),
        ),
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
                  const Text('Add Vendor'),
                  const Spacer(),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Form(
                  key: addVendorForm,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        onChanged: (value) {
                          name = value;
                        },
                        decoration: getInputDecoration(
                            hint: 'Full Name', errorColor: Colors.red),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextFormField(
                        controller: cnameController,
                        onChanged: (value) {
                          cName = value;
                        },
                        decoration: getInputDecoration(
                            hint: 'Company Name', errorColor: Colors.red),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextFormField(
                        controller: dnameController,
                        onChanged: (value) {
                          dName = value;
                        },
                        decoration: getInputDecoration(
                            hint: 'Display Name', errorColor: Colors.red),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextFormField(
                        controller: emailController,
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: getInputDecoration(
                            hint: 'Email (optional)', errorColor: Colors.red),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextFormField(
                        controller: phoneController,
                        onChanged: (value) {
                          phone = value;
                        },
                        decoration: getInputDecoration(
                            hint: 'Phone No.(optional)',
                            errorColor: Colors.red),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet<dynamic>(
                              backgroundColor: t,
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return AddBillingShippingAddress(
                                  onAddressSaved: setAddresSaved,
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
                                  isAddressSaved
                                      ? LineIcons.checkCircleAlt
                                      : LineIcons.plusCircle,
                                  color: blue,
                                ),
                                Text(
                                  isAddressSaved
                                      ? 'Saved Address'
                                      : 'Add Billing & Shipping Address',
                                  style: TextStyle(
                                      color: blue, fontWeight: FontWeight.w300),
                                  textScaleFactor: 1,
                                ),
                              ],
                            )),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextFormField(
                        controller: remarksController,
                        onChanged: (value) {
                          remarks = value;
                        },
                        decoration: getInputDecoration(
                            hint: 'Remarks (for internal use)',
                            errorColor: Colors.red),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                    ],
                  )),
            ],
          ),
        ),
      )),
    );
  }
}
