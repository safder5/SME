import 'package:ashwani/Models/address_model.dart';
import 'package:ashwani/Models/customer_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerProvider with ChangeNotifier {
  List<CustomerModel> _customers = [];
  List<CustomerModel> get customer => _customers;

  Future<void> addCustomer(CustomerModel customerData, DocumentReference docRef,
      AddressModel? bill, AddressModel? ship) async {
    try {
      Map<String, dynamic> customer_data = {
        'name': customerData.name,
        'companyName': customerData.companyName ?? '',
        'displayname': customerData.displayname,
        'email': customerData.email ?? '',
        'phone': customerData.phone ?? '',
        'remarks': customerData.remarks ?? '',
        'business': customerData.business,
      };
      docRef.set(customer_data);
      if (ship != null) {
        Map<String, dynamic> customerShipAddress = {
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
            .set(customerShipAddress);
      }
      if (bill != null) {
        Map<String, dynamic> customerBillAddress = {
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
            .set(customerBillAddress);
      }
      notifyListeners();
    } catch (e) {
      print('errror uploading customer');
    }
  }

  Future<void> fetchAllCustomers(CollectionReference collRef) async {
    try {
      final customerSnapshot = await collRef.get();
      _customers = customerSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return CustomerModel(
          name: data['name'],
          displayname: data['displayname'],
          companyName: data['companyName'],
          email: data['email'],
          phone: data['phone'],
          remarks: data['remarks'],
          business: null,
        );
      }).toList();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
  List<String> getAllCustomerNames() {
    return _customers.map((customer) => customer.name!).toList();
  }
  void filterCustomers(String query) {
    _customers = _customers
        .where((customer) =>
            customer.toString().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  Future<void> removeCustomer() async {
    try {} catch (e) {
      print(e);
    }
  }
}
