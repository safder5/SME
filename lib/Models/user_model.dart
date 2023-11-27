import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String companyName;
  final Timestamp invDay;
  final String photo;

  UserModel({
    required this.name,
    required this.companyName,
    required this.invDay,
    required this.photo,
  });
}
