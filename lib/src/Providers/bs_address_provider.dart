import 'package:SMEflow/src/Models/address_model.dart';
import 'package:flutter/material.dart';

class BSAddressProvider with ChangeNotifier {
  AddressModel? _billing = AddressModel();
  AddressModel? _shipping = AddressModel();

  // List<BillingShippingAddressModel> _bs = [];
  AddressModel? get billing => _billing;
  AddressModel? get shipping => _shipping;

  void setAddress(AddressModel? ship, AddressModel? bill) {
    if (ship != null) {
      _shipping = ship;
      _billing = bill;
      notifyListeners();
    }
  }

  void submitBSA(AddressModel bsatoSubmit) {}

  void clearAddresses() {
    _billing = null;
    _shipping = null;
  }

  void reset() {
    _billing = null;
    _shipping == null;
    notifyListeners();
  }
}
