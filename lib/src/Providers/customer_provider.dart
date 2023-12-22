import 'package:ashwani/src/Models/address_model.dart';
import 'package:ashwani/src/Models/customer_model.dart';
import 'package:ashwani/src/Models/sales_order.dart';
import 'package:ashwani/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerProvider with ChangeNotifier {
  List<CustomerModel> _customers = [];
  final List<String> _customerNames = [];
  List<CustomerModel> get customers => _customers;
  List<String> get customerNames => _customerNames;

  final CollectionReference cR = FirebaseFirestore.instance
      .collection('UserData')
      .doc(UserData().userEmail)
      .collection('Customers');

  void addCustomerinProvider(
      CustomerModel customerData, AddressModel? bill, AddressModel? ship) {
    final cd = customerData;
    cd.bill = bill;
    cd.ship = ship;
    _customers.add(cd);
    notifyListeners();
  }

  Future<void> addCustomer(CustomerModel customerData, DocumentReference docRef,
      AddressModel? bill, AddressModel? ship) async {
    try {
      Map<String, dynamic> customerDATA = {
        'name': customerData.name,
        'companyName': customerData.companyName ?? '',
        'displayname': customerData.displayname,
        'email': customerData.email ?? '',
        'phone': customerData.phone ?? '',
        'remarks': customerData.remarks ?? '',
        'business': customerData.business,
      };
      docRef.set(customerDATA);
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

  Future<void> fetchAllCustomers() async {
    try {
      _customers.clear();
      final customerSnapshot = await cR.get();
      _customers = customerSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return CustomerModel(
          name: data['name'] ?? '',
          displayname: data['displayname'] ?? '',
          companyName: data['companyName'] ?? '',
          email: data['email'] ?? '',
          phone: data['phone'] ?? '',
          remarks: data['remarks'] ?? '',
          business: data['business'] ?? '',
        );
      }).toList();
      print('fetchedcustomers ${_customers.length}');
      notifyListeners();
    } catch (e) {
      print('error getting fetch all customers $e');
    }
  }

  List<String> getAllCustomerNames() {
    return _customers.map((customer) => customer.name!).toList();
  }

  void filterCustomers(String query) {
    _customers = _customers
        .where((customer) => customer.toString().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  Future<void> removeCustomer() async {
    try {} catch (e) {
      print(e);
    }
  }

  Future<void> uploadOrderInCustomersProfile(
      SalesOrderModel so, String customerName) async {
    try {
      await cR
          .doc(customerName)
          .collection('salesOrderIds')
          .doc((so.orderID).toString())
          .set({
        'orderId': so.orderID,
      });
      notifyListeners();
    } catch (e) {
      print('error uploadOrderinCustomerProfile $e');
    }
  }

  void reset() {
    try {
      _customerNames.clear();
      _customers.clear();
      notifyListeners();
    } catch (e) {
      print('error customer reset');
    }
  }
}
