import 'package:ashwani/Models/address_model.dart';

class CustomerModel {
  
  final String? name;
  final String? displayname;
  String? companyName;
  String? email;
  String? phone;
  String? remarks;
  AddressModel? bill;
  AddressModel? ship;
  final bool? business;

  CustomerModel({
    required this.name,
    required this.displayname,
    this.companyName,
    this.email,
    this.phone,
    this.remarks,
    this.bill,
    this.ship,
    required this.business,
  });
}
