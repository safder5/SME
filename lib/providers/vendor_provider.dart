import 'package:ashwani/Models/address_model.dart';
import 'package:ashwani/Models/vendor_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VendorProvider with ChangeNotifier {
  final List<VendorModel> _vm = [];
  List<VendorModel> get vm => _vm;

  Future<void> addVendor(VendorModel vendorData, DocumentReference docRef,
      AddressModel? bill, AddressModel? ship) async {
    try {
      Map<String, dynamic> vendor_data = {
        'name': vendorData.name,
        'companyName': vendorData.companyName ?? '',
        'displayname': vendorData.displayName,
        'email': vendorData.email ?? '',
        'phone': vendorData.phone ?? '',
        'remarks': vendorData.remarks ?? '',
      };
      docRef.set(vendor_data);
      if (ship != null) {
        Map<String, dynamic> vendorShipAddress = {
          'street': ship.street ?? '',
          'city': ship.city ?? '',
          'state': ship.state ?? '',
          'country': ship.country ?? '',
          'zipcode': ship.zipCode ?? '',
          'phone': ship.phone ?? '',
        };
        await docRef
            .collection('addresses')
            .doc('ship')
            .set(vendorShipAddress);
      }
      if (bill != null) {
        Map<String, dynamic> vendorBillAddress = {
          'street': bill.street ?? '',
          'city': bill.city ?? '',
          'state': bill.state ?? '',
          'country': bill.country ?? '',
          'zipcode': bill.zipCode ?? '',
          'phone': bill.phone ?? '',
        };
        await docRef
            .collection('addresses')
            .doc('bill')
            .set(vendorBillAddress);
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
  Future<void> removeVendor() async {
    try {} catch (e) {
      print(e);
    }
  }
}
