import 'package:ashwani/src/Models/address_model.dart';
import 'package:ashwani/src/Providers/bs_address_provider.dart';
import 'package:ashwani/src/Services/helper.dart';
import 'package:ashwani/src/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBillingShippingAddress extends StatefulWidget {
  const AddBillingShippingAddress({super.key, required this.onAddressSaved});
  final Function(bool) onAddressSaved;

  @override
  State<AddBillingShippingAddress> createState() =>
      _AddBillingShippingAddressState();
}

class _AddBillingShippingAddressState extends State<AddBillingShippingAddress> {
  // String? street;
  // String? city;
  // String? state;
  // String? country;
  // String? zipcode;
  // String? phone;
  // String? bstreet;
  // String? bcity;
  // String? bstate;
  // String? bcountry;
  // String? bzipcode;
  // String? bphone;
  TextEditingController streetCtrl = TextEditingController();
  TextEditingController cityCtrl = TextEditingController();
  TextEditingController stateCtrl = TextEditingController();
  TextEditingController countryCtrl = TextEditingController();
  TextEditingController zipcodeCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController bstreetCtrl = TextEditingController();
  TextEditingController bcityCtrl = TextEditingController();
  TextEditingController bstateCtrl = TextEditingController();
  TextEditingController bcountryCtrl = TextEditingController();
  TextEditingController bzipcodeCtrl = TextEditingController();
  TextEditingController bphoneCtrl = TextEditingController();
  AddressModel? ship;
  AddressModel? bill;

  void sameAsAbove() {
    setState(() {
      bstreetCtrl.text = streetCtrl.text;
      bcityCtrl.text = cityCtrl.text;
      bstateCtrl.text = stateCtrl.text;
      bcountryCtrl.text = countryCtrl.text;
      bzipcodeCtrl.text = zipcodeCtrl.text;
      bphoneCtrl.text = phoneCtrl.text;
    });
  }

  void _handleSaveAddress() {
    if (ship != null) {
      widget.onAddressSaved(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final addresProvider = Provider.of<BSAddressProvider>(context);
    return Container(
      decoration: BoxDecoration(
          color: w,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      height: MediaQuery.of(context).size.height * 0.85,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Address'),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              const Text('Shipping'),
              const SizedBox(
                height: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                      controller: streetCtrl,
                      cursorColor: blue,
                      cursorWidth: 1,
                      onChanged: (String? val) {
                        // tandc = val;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: getInputDecoration(
                          hint: 'Street', errorColor: Colors.red)),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                      controller: cityCtrl,
                      cursorColor: blue,
                      cursorWidth: 1,
                      onChanged: (String? val) {
                        // tandc = val;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: getInputDecoration(
                          hint: 'City', errorColor: Colors.red)),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                      controller: stateCtrl,
                      cursorColor: blue,
                      cursorWidth: 1,
                      onChanged: (String? val) {
                        // tandc = val;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: getInputDecoration(
                          hint: 'State', errorColor: Colors.red)),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                      controller: countryCtrl,
                      cursorColor: blue,
                      cursorWidth: 1,
                      onChanged: (String? val) {
                        // tandc = val;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: getInputDecoration(
                          hint: 'Country/Region', errorColor: Colors.red)),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                      controller: zipcodeCtrl,
                      cursorColor: blue,
                      cursorWidth: 1,
                      onChanged: (String? val) {
                        // tandc = val;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: getInputDecoration(
                          hint: 'Zip Code', errorColor: Colors.red)),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                      controller: phoneCtrl,
                      cursorColor: blue,
                      cursorWidth: 1,
                      onChanged: (String? val) {
                        // tandc = val;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: getInputDecoration(
                          hint: 'Phone No.', errorColor: Colors.red)),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  const Text('Billing'),
                  const Spacer(),
                  GestureDetector(
                      onTap: () {
                        sameAsAbove();
                        // make the bottom fields same as above
                      },
                      child: Text(
                        'Same as Above',
                        style: TextStyle(color: b.withOpacity(0.6), fontSize: 10),
                      ))
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                      controller: bstreetCtrl,
                      cursorColor: blue,
                      cursorWidth: 1,
                      onChanged: (String? val) {
                        // tandc = val;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: getInputDecoration(
                          hint: 'Street', errorColor: Colors.red)),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                      controller: bcityCtrl,
                      cursorColor: blue,
                      cursorWidth: 1,
                      onChanged: (String? val) {
                        // tandc = val;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: getInputDecoration(
                          hint: 'City', errorColor: Colors.red)),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                      controller: bstateCtrl,
                      cursorColor: blue,
                      cursorWidth: 1,
                      onChanged: (String? val) {
                        // tandc = val;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: getInputDecoration(
                          hint: 'State', errorColor: Colors.red)),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                      controller: bcountryCtrl,
                      cursorColor: blue,
                      cursorWidth: 1,
                      onChanged: (String? val) {
                        // tandc = val;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: getInputDecoration(
                          hint: 'Country/Region', errorColor: Colors.red)),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                      controller: bzipcodeCtrl,
                      cursorColor: blue,
                      cursorWidth: 1,
                      onChanged: (String? val) {
                        // tandc = val;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: getInputDecoration(
                          hint: 'Zip Code', errorColor: Colors.red)),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                      controller: bphoneCtrl,
                      cursorColor: blue,
                      cursorWidth: 1,
                      onChanged: (String? val) {
                        // tandc = val;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: getInputDecoration(
                          hint: 'Phone No.', errorColor: Colors.red)),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  ship = AddressModel(
                      street: streetCtrl.text,
                      city: cityCtrl.text,
                      state: stateCtrl.text,
                      country: countryCtrl.text,
                      zipCode: zipcodeCtrl.text,
                      phone: phoneCtrl.text);
                  bill = AddressModel(
                      street: bstreetCtrl.text,
                      city: bcityCtrl.text,
                      state: bstateCtrl.text,
                      country: bcountryCtrl.text,
                      zipCode: bzipcodeCtrl.text,
                      phone: bphoneCtrl.text);
                  addresProvider.setAddress(ship, bill);
                  _handleSaveAddress();
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
                    'Add Addresses',
                    style: TextStyle(
                      color: w, fontSize: 14
                    ),
                  )),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.4,)
            ],
          ),
        ),
      ),
    );
  }
}
