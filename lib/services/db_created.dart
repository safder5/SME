import 'package:ashwani/landingbypass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DBCreatingPage extends StatefulWidget {
  const DBCreatingPage({super.key, required this.email});
  final String email;

  @override
  State<DBCreatingPage> createState() => _DBCreatingPageState();
}

class _DBCreatingPageState extends State<DBCreatingPage> {
  final _fs = FirebaseFirestore.instance;
  // final _auth = FirebaseAuth.instance;
  createDatabase() {
    _fs
        .collection('UserData')
        .doc(widget.email)
        .collection('AllData')
        .doc('PersonalDetails')
        .set({'name': 'Full Name', 'orgName': '', 'orgType': ''});
    _fs.collection('Users').doc(widget.email).set({'id': widget.email});
    // _fs
    //     .collection('UserData')
    //     .doc(widget.email)
    //     .collection('items')
    //     .doc('')
    //     .set({});
    //removed cuz doc name has to be the item name when created also saves memory
  }

  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return const LandingBypass();
  }
}
