import 'package:SMEflow/src/Models/user_model.dart';
import 'package:SMEflow/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  List<UserModel> _user = [];
  List<UserModel> get user => _user;
  Future<void> getUserDetails() async {
   
    try {
      final fs = FirebaseFirestore.instance
          .collection('UserData')
          .doc(UserData().userEmail)
          .collection('AllData');
      final snap = await fs.get();
      for (var doc in snap.docs) {
        Map<String, dynamic> data = doc.data();
        UserModel u = UserModel(
          name: data['name'],
          companyName: data['orgName'],
          invDay: data['inventory_start_date'],
          photo: data['photoURL'] ?? 'lib/images/logoashapp.png',
        );
        _user = [u];
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void reset() {
     try {
       _user.clear();
    notifyListeners();
    } catch (e) {
      print('error userp reset');
    }
  }
}
