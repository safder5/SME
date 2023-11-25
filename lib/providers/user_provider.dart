import 'package:ashwani/Models/user.dart';
import 'package:ashwani/Models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  late UserModel _user;
  Future<UserModel> get user async => _user;
  Future<void> getUserDetails() async {
    final auth = FirebaseAuth.instance.currentUser;
    final fs =  FirebaseFirestore.instance
        .collection('UserData')
        .doc(auth!.email)
        .collection('AllData')
        .doc('PersonalDetails');
        
  }
}
