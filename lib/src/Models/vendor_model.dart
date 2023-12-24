import 'package:ashwani/src/Models/address_model.dart';

class VendorModel {
  final String? name;
  String? companyName;
  final String? displayName;
  String? email;
  String? phone;
  String? remarks;
  AddressModel? billingAdd;
  AddressModel? shippingAdd;

  VendorModel({
    required this.name,
    required this.displayName,
    this.companyName,
    this.email,
    this.phone,
    this.remarks,
    this.shippingAdd,
    this.billingAdd
  });
}
