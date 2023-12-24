
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../constants.dart';
import '../helper.dart';
import 'signupauth.dart';

class SetupAccount extends StatefulWidget {
  const SetupAccount({super.key, required this.photoURL});
  final String photoURL;

  @override
  State<SetupAccount> createState() => _SetupAccountState();
}

class _SetupAccountState extends State<SetupAccount> {
  DateTime cdate = DateTime.now();
  final _fs = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance.currentUser;

  Future<void> createDatabase() async {
    try {
      await _fs
          .collection('UserData')
          .doc(_auth!.email)
          .collection('AllData')
          .doc('PersonalDetails')
          .set({
        'name': _nameCtrl.text.trim(),
        'orgName': _companyNameCtrl.text.trim(),
        'orgType': 'SME',
        'inventory_start_date': cdate,
        'phone_number': _auth!.phoneNumber ?? 0,
        'photoURL': widget.photoURL
      });
    } catch (e) {
      print("Error in creating database $e");
    }
    await _fs.collection('Users').doc(_auth!.email).set({'id': _auth!.email});
  }

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _companyNameCtrl = TextEditingController();
  final TextEditingController _countryCtrl = TextEditingController();

  // Widget displayProfilePicture() {
  //   return CircleAvatar(
  //     backgroundColor: blue,
  //     radius: 30, // Adjust the radius as needed
  //     backgroundImage: widget.photoURL != 'na'
  //         ? NetworkImage(widget.photoURL)
  //         : const AssetImage('assets/default_profile_image.png')
  //             as ImageProvider,
  //     // Use a default image in case photoURL is null or fails to load
  //     // Replace 'default_profile_image.png' with your default image asset path
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 9,
                      child: Text(
                        'Let\'s Setup Your Account',
                        style: TextStyle(
                            color: b,
                            fontSize: 28,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                          onPressed: () async {
                            // logout and go back to the previous page
                            await FirebaseAuth.instance.signOut();
                            if (!context.mounted) return;
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpAuthPage()));
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/signupPage', (route) => false);
                          },
                          child: Icon(
                            Icons.more_vert,
                            color: b,
                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                // displayProfilePicture(),
                CircleAvatar(
                  backgroundColor: blue,
                  radius: 30, // Adjust the radius as needed
                  backgroundImage: widget.photoURL != 'na'
                      ? NetworkImage(widget.photoURL)
                      : const AssetImage('assets/default_profile_image.png')
                          as ImageProvider,
                  // Use a default image in case photoURL is null or fails to load
                  // Replace 'default_profile_image.png' with your default image asset path
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: _nameCtrl.text.isEmpty ? b.withOpacity(0.02) : t,
                      borderRadius: BorderRadius.circular(5)),
                  child: TextField(
                    controller: _nameCtrl,
                    decoration:
                        logInputDecoration(hint: 'Full Name', errorColor: r)
                            .copyWith(),
                    // onChanged: (value) {
                    //   colorOfTextField();
                    // },
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: _companyNameCtrl.text.isEmpty
                          ? b.withOpacity(0.02)
                          : t,
                      borderRadius: BorderRadius.circular(5)),
                  child: TextField(
                    controller: _companyNameCtrl,
                    decoration:
                        logInputDecoration(hint: 'Company Name', errorColor: r)
                            .copyWith(),
                    // onChanged: (value) {
                    //   colorOfTextField();
                    // },
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        showCountryPicker(
                          useSafeArea: true,
                          context: context,
                          //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                          exclude: <String>['KN', 'MF'],
                          favorite: <String>['IN', 'US'],
                          //Optional. Shows phone code before the country name.
                          showPhoneCode: false,
                          onSelect: (Country country) {
                            setState(() {
                              _countryCtrl.text = country.displayName;
                            });
                          },
                          // Optional. Sets the theme for the country list picker.
                          countryListTheme: CountryListThemeData(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 32),
                            // Optional. Sets the border radius for the bottomsheet.
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                            // Optional. Styles the search field.
                            inputDecoration: logInputDecoration(
                                hint: 'Search Country', errorColor: r),
                            // Optional. Styles the text in the search field
                            searchTextStyle: TextStyle(
                              color: b,
                              fontSize: 18,
                            ),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: t,
                          surfaceTintColor: blue,
                          shadowColor: r,
                          foregroundColor: blue),
                      child: Text(
                        _countryCtrl.text.isEmpty
                            ? 'Select Country'
                            : _countryCtrl.text,
                        style: TextStyle(color: blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                GestureDetector(
                  onTap: () async {
                    // try {
                    //   await _auth.createUserWithEmailAndPassword(
                    //       email: _emailCtrl.text.trim(),
                    //       password: _pwdCtrl.text.trim());
                    // } catch (e) {
                    //   print(e);
                    // }
                    await createDatabase();
                    if (_companyNameCtrl.text.isNotEmpty &&
                        _nameCtrl.text.isNotEmpty &&
                        _countryCtrl.text.isNotEmpty) {
                      if (!context.mounted) return;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyApp()));
                    } else {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: w,
                          content: Row(
                            children: [
                              Icon(
                                Icons.error_sharp,
                                color: r,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Fill All Required Details.',
                                style: TextStyle(color: r),
                              ),
                            ],
                          )));
                    }
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: blue, borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: Text(
                            'Setup Account',
                            style: TextStyle(color: w, fontSize: 14),
                          ),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 48,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
