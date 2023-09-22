import 'package:ashwani/Models/b_s_address.dart';
import 'package:flutter/material.dart';

class BSAddressProvider with ChangeNotifier {
  AddressModel? _billing = AddressModel();
  AddressModel? _shipping = AddressModel();

  // List<BillingShippingAddressModel> _bs = [];
  AddressModel? get billing => _billing;
  AddressModel? get shipping => _shipping;

  void submitBSA(AddressModel bsatoSubmit) {
    
  }
}
