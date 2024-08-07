import 'package:ashwani/src/Services/authorizeUser/authentication.dart';
import 'package:ashwani/src/Services/authorizeUser/setup_account.dart';
import 'package:ashwani/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class SignUpAuthPage extends StatefulWidget {
  const SignUpAuthPage({super.key});

  @override
  State<SignUpAuthPage> createState() => _SignUpAuthPageState();
}

class _SignUpAuthPageState extends State<SignUpAuthPage> {
  Future<bool> checkIfUserDataExists(String email) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      // Access Firestore and check for data associated with the user's UID
      DocumentSnapshot<Map<String, dynamic>> userData =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(user!.email) // Assuming 'users' is your collection name
              .get();
      final bool present = userData['id'] == user.email;
      return present; // Return true if data exists for the user
    } catch (e) {
      print('Error checking user data: $e');
      return false; // Handle the error as needed
    }
  }

  final String? selectedCountry = '';
  late final ValueChanged<String> onCountrySelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: w,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  // child: Center(
                  //   child:  Image(image: AssetImage('lib/images/sme.png')),
                  // ),
                ),
                // const Icon(
                //   Icons.group_add,
                //   size: 32,
                // ),
                const Spacer(),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('lib/images/applogo.png'),
                      width: 150,
                    ),
                  ],
                ),
                // SvgPicture.asset('lib/icons/sme.svg',width: 100,height: 100,),
                // Text(
                //   'Register',
                //   style: TextStyle(
                //       color: b.withOpacity(0.8),
                //       fontSize: 32,
                //       fontWeight: FontWeight.w800),
                // ),

                // Row(
                //   children: [
                //     const Text('Got an account ?'),
                //     const Spacer(),
                //     GestureDetector(
                //         onTap: () {
                //           Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (context) => const LoginAuthPage()));
                //         },
                //         child: Text(
                //           'Log in here',
                //           style: TextStyle(
                //               color: blue, fontWeight: FontWeight.w500),
                //         )),
                //     Icon(
                //       Icons.arrow_forward,
                //       size: 14,
                //       color: blue,
                //     )
                //   ],
                // ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        print('Clicked signin google');
                        // if (_nameCtrl.text.isEmpty) {
                        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //       content: Text(
                        //           'Kindly Enter a name and Then Sign up with google')));
                        // }
                        try {
                          Authentication auth = Authentication();
                          User? user = await auth.signInWithGoogle();
                          //here check if registered

                          if (user != null) {
                            bool emailExists =
                                await checkIfUserDataExists(user.email!);
                            // Handle successful sign-in
                            print('Signed in user: ${user.displayName}');
                            if (!context.mounted) return;
                            emailExists
                                ? Navigator.of(context, rootNavigator: true)
                                    .pushReplacement(MaterialPageRoute(
                                        builder: (context) => const MyApp()))
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SetupAccount(
                                              photoURL: user.photoURL ?? 'na',
                                            )));
                          } else {
                            if (!context.mounted) return;
                            // Handle sign-in failure or cancellation
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Sign-in failed or cancelled')));
                            // print('Sign-in failed or cancelled');
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.4,
                        // width: ,
                        decoration: BoxDecoration(
                            color: w,
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.black.withOpacity(0.1),
                            //     spreadRadius: 2,
                            //     blurRadius: 5,
                            //     offset: const Offset(
                            //         0, 3), // changes the shadow position
                            //   ),
                            // ],
                            border: Border.all(
                                width: 1, color: b.withOpacity(0.07)),
                            borderRadius: BorderRadius.circular(20)),
                        child: const Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image(
                                image: AssetImage('lib/images/gicon.png'),
                                width: 22,
                                height: 22,
                              ),
                              Spacer(),
                              Text(
                                'with',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Google',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        //  authentication for apple
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.4,
                        // width: ,
                        decoration: BoxDecoration(
                            color: w,
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.black.withOpacity(0.1),
                            //     spreadRadius: 2,
                            //     blurRadius: 5,
                            //     offset: const Offset(
                            //         0, 3), // changes the shadow position
                            //   ),
                            // ],
                            border: Border.all(
                                width: 1, color: b.withOpacity(0.07)),
                            borderRadius: BorderRadius.circular(20)),
                        child: const Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image(
                                image: AssetImage('lib/images/aicon.png'),
                                width: 22,
                                height: 22,
                              ),
                              Spacer(),
                              Text(
                                'with',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Apple',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
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
