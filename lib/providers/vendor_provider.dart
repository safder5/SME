import 'package:ashwani/Models/address_model.dart';
import 'package:ashwani/Models/purchase_order.dart';
import 'package:ashwani/Models/vendor_model.dart';
import 'package:ashwani/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VendorProvider with ChangeNotifier {
  List<VendorModel> _vendors = [];
  List<VendorModel> get vendors => _vendors;

  final CollectionReference cR = FirebaseFirestore.instance
      .collection('UserData')
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection('Vendors');

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
        await docRef.collection('addresses').doc('ship').set(vendorShipAddress);
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
        await docRef.collection('addresses').doc('bill').set(vendorBillAddress);
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addVendorinProvider(
      VendorModel vendorData, AddressModel? bill, AddressModel? ship) async {
    try {
      VendorModel vd = vendorData;
      vd.billingAdd = bill;
      vd.shippingAdd = ship;
      _vendors.add(vd);
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchAllVendors() async {
    try {
      final customerSnapshot = await cR.get();
      _vendors = customerSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return VendorModel(
          name: data['name'],
          displayName: data['displayname'],
          companyName: data['companyName'],
          email: data['email'],
          phone: data['phone'],
          remarks: data['remarks'],
          // business: data['business'],
        );
      }).toList();
      notifyListeners();
    } catch (e) {
      print('error getting fetch all customers $e');
    }
    notifyListeners();
  }

  List<String> getAllVendorNames() {
    return _vendors.map((vendor) => vendor.name!).toList();
  }

  Future<void> uploadOrderInVendorsProfile(
      PurchaseOrderModel po, String vendorName) async {
    try {
      await cR
          .doc(vendorName)
          .collection('salesOrderIds')
          .doc((po.orderID).toString())
          .set({
        'orderId': po.orderID,
      });
      notifyListeners();
    } catch (e) {
      print('error uploadOrderinCustomerProfile $e');
    }
  }
}
