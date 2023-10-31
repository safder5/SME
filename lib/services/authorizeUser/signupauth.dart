import 'package:ashwani/Services/db_created.dart';
import 'package:ashwani/country_state/country_select.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

import '../../constants.dart';
import '../helper.dart';

class SignUpAuthPage extends StatefulWidget {
  const SignUpAuthPage({super.key});

  @override
  State<SignUpAuthPage> createState() => _SignUpAuthPageState();
}

class _SignUpAuthPageState extends State<SignUpAuthPage> {
  void createUser() async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool _obscureText = false;
  bool _sendCode = false;
  String _country = '';
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _pwdCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _codeCtrl = TextEditingController();
  final TextEditingController _countryCtrl = TextEditingController();
  // TextEditingController _stateCtrl = TextEditingController();
  Color bgEmail = b.withOpacity(0.02);
  Color bgpwd = b.withOpacity(0.02);
  Color bgName = b.withOpacity(0.02);
  Color bgCode = b.withOpacity(0.02);
  Color bgCtry = b.withOpacity(0.02);
  // Color bgState = b.withOpacity(0.02);
  void colorOfTextField() {
    if (_emailCtrl.text.isNotEmpty) {
      setState(() {
        bgEmail = t;
      });
    }
    if (_pwdCtrl.text.isNotEmpty) {
      setState(() {
        bgpwd = t;
      });
    }
    if (_codeCtrl.text.isNotEmpty) {
      setState(() {
        bgCode = t;
      });
    }
    if (_nameCtrl.text.isNotEmpty) {
      setState(() {
        bgName = t;
      });
    }
    if (_countryCtrl.text.isNotEmpty) {
      setState(() {
        bgName = t;
      });
    }
  }

  final String? selectedCountry = '';
  late final ValueChanged<String> onCountrySelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                        color: b.withOpacity(0.8),
                        fontSize: 24,
                        fontWeight: FontWeight.w500),
                  ),
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
                    onChanged: (value) {
                      colorOfTextField();
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: _emailCtrl.text.isEmpty ? b.withOpacity(0.02) : t,
                      borderRadius: BorderRadius.circular(5)),
                  child: TextField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: logInputDecoration(
                            hint: 'Enter email address', errorColor: r)
                        .copyWith(),
                    onChanged: (value) {
                      colorOfTextField();
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: _pwdCtrl.text.isEmpty ? b.withOpacity(0.02) : t,
                      borderRadius: BorderRadius.circular(5)),
                  child: TextField(
                    controller: _pwdCtrl,
                    obscureText: _obscureText,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: logInputDecoration(
                            hint: 'Enter password ', errorColor: r)
                        .copyWith(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText =
                                !_obscureText; // Toggle between obscured and revealed
                          });
                        },
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: _obscureText ? b : Colors.grey,
                          size: 18,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      colorOfTextField();
                    },
                  ),
                ),
                // Container(
                //   decoration: BoxDecoration(
                //       color: _codeCtrl.text.isEmpty ? b.withOpacity(0.02) : t,
                //       borderRadius: BorderRadius.circular(5)),
                //   child: TextField(
                //     controller: _codeCtrl,
                //     keyboardType: const TextInputType.numberWithOptions(),
                //     decoration:
                //         logInputDecoration(hint: 'Enter Code', errorColor: r)
                //             .copyWith(
                //                 suffix: GestureDetector(
                //                     onTap: () {
                //                       setState(() {
                //                         _sendCode = true;
                //                       });
                //                     },
                //                     child: Text(
                //                       _sendCode ? 'Resend' : 'Send Code',
                //                       style: TextStyle(
                //                           fontSize: 10,
                //                           color: b.withOpacity(0.31)),
                //                     ))),
                //     onChanged: (value) {
                //       colorOfTextField();
                //     },
                //   ),
                // ),
                Container(
                  decoration: BoxDecoration(
                      color:
                          _countryCtrl.text.isEmpty ? b.withOpacity(0.02) : t,
                      borderRadius: BorderRadius.circular(5)),
                  child: TextField(
                    readOnly: true,
                    controller: _countryCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: logInputDecoration(
                            hint: 'Select Country', errorColor: r)
                        .copyWith(
                            suffixIcon: GestureDetector(
                      onTap: () {
                        showCountryPicker(
                          useSafeArea: true,
                          context: context,
                          //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                          exclude: <String>['KN', 'MF'],
                          favorite: <String>['IN', 'US'],
                          //Optional. Shows phone code before the country name.
                          showPhoneCode: false,
                          onSelect: (Country country) {
                            _countryCtrl.text = country.displayName;
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
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 24,
                        color: b32,
                      ),
                    )),
                    onChanged: (value) {
                      colorOfTextField();
                    },
                  ),
                ),
                // Container(
                //   decoration: BoxDecoration(
                //       color: _emailCtrl.text.isEmpty ? b.withOpacity(0.02) : t,
                //       borderRadius: BorderRadius.circular(5)),
                //   child: TextField(
                //     readOnly: true,
                //     controller: _emailCtrl,
                //     keyboardType: TextInputType.emailAddress,
                //     decoration: logInputDecoration(
                //             hint: 'Enter email address', errorColor: r)
                //         .copyWith(
                //             suffix: GestureDetector(
                //       onTap: () {},
                //       child: Icon(
                //         Icons.keyboard_arrow_down,
                //         size: 18,
                //         color: b32,
                //       ),
                //     )),
                //     onChanged: (value) {
                //       colorOfTextField();
                //     },
                //   ),
                // ),

                GestureDetector(
                  onTap: () async {
                    try {
                      await _auth.createUserWithEmailAndPassword(
                          email: _emailCtrl.text.trim(), password: _pwdCtrl.text.trim());
                     
                    } catch (e) {
                      print(e);
                    }
                     if (!context.mounted) return;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DBCreatingPage(email: email,name: _nameCtrl.text.trim(),)));
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
                Visibility(
                  visible: _sendCode,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'we’ve sent a 6-character code to: ${_nameCtrl.text}@gmail.com',
                        style:
                            TextStyle(fontSize: 10, color: b.withOpacity(0.5)),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'By continuing you acknowledge that you have read and understood and agree to our',
                        style: TextStyle(
                            fontSize: 10.0, color: b.withOpacity(0.28)),
                      ),
                      TextSpan(
                        text: 'Terms of Service ',
                        style: TextStyle(
                          color: blue,
                          decoration: TextDecoration.underline,
                          fontSize: 10.0,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Handle the first button click here
                            print('Button 1 clicked');
                          },
                      ),
                      TextSpan(
                        text: 'and',
                        style: TextStyle(
                            fontSize: 10.0, color: b.withOpacity(0.28)),
                      ),
                      TextSpan(
                        text: 'Privacy Policy ',
                        style: TextStyle(
                          color: blue,
                          decoration: TextDecoration.underline,
                          fontSize: 10.0,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Handle the second button click here
                            print('Button 2 clicked');
                          },
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
