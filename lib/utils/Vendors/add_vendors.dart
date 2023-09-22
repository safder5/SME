import 'package:ashwani/Screens/addAddressBillingShipping.dart/add_address.dart';
import 'package:ashwani/constants.dart';
import 'package:ashwani/Models/b_s_address.dart';
import 'package:ashwani/Models/vendor_model.dart';
import 'package:ashwani/Services/helper.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: ,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 32.0, left: 16.0, right: 16.0),
        child: GestureDetector(
          onTap: () async {
            //submit everything after validation is processed
            final VendorModel vm = VendorModel(
              name: nameController.text,
              displayName: dnameController.text,
              companyName: cnameController.text,
              email: emailController.text,
              phone: phoneController.text,
              remarks: remarksController.text,
              billingAdd: bill,
              shippingAdd: ship,
            );
            print(vm.displayName);
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
                                    return AddBillingShippingAddress();
                                  });
                        },
                        child:  AbsorbPointer(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.transparent,
                                    border:
                                        Border.all(width: 0.6, color: blue)),
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
                                          color: blue,
                                          fontWeight: FontWeight.w300),
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
