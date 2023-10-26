import 'package:ashwani/Services/authorizeUser/signupauth.dart';
import 'package:ashwani/Services/db_created.dart';
import 'package:ashwani/Services/helper.dart';
import 'package:ashwani/constants.dart';
import 'package:ashwani/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class LoginAuthPage extends StatefulWidget {
  const LoginAuthPage({super.key});

  @override
  State<LoginAuthPage> createState() => _LoginAuthPageState();
}

class _LoginAuthPageState extends State<LoginAuthPage> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool _obscureText = false;
  TextEditingController _emailCtrl = TextEditingController();
  TextEditingController _pwdCtrl = TextEditingController();
  Color bgEmail = b.withOpacity(0.02);
  Color bgpwd = b.withOpacity(0.02);
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
  }

  checkAuthentication() {
    // _auth.currentUser!.email? :
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Text(
              'Login',
              style: TextStyle(
                  color: b.withOpacity(0.8),
                  fontSize: 24,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Container(
              decoration: BoxDecoration(
                  color: _emailCtrl.text.isEmpty ? b.withOpacity(0.02) : t,
                  borderRadius: BorderRadius.circular(5)),
              child: TextField(
                controller: _emailCtrl,
                cursorColor: blue,
                cursorWidth: 1,
                keyboardType: TextInputType.emailAddress,
                decoration: logInputDecoration(
                        hint: 'Enter email address', errorColor: r)
                    .copyWith(),
                onChanged: (value) {
                  colorOfTextField();
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Container(
              decoration: BoxDecoration(
                  color: _pwdCtrl.text.isEmpty ? b.withOpacity(0.02) : t,
                  borderRadius: BorderRadius.circular(5)),
              child: TextField(
                controller: _pwdCtrl,
                cursorColor: blue,
                cursorWidth: 1,
                obscureText: _obscureText,

                // keyboardType: TextInputType.visiblePassword,
                decoration:
                    logInputDecoration(hint: 'Enter password ', errorColor: r)
                        .copyWith(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText =
                            !_obscureText; // Toggle between obscured and revealed
                      });
                    },
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 15),
            child: GestureDetector(
                onTap: () async {
                  try {
                    await _auth.signInWithEmailAndPassword(
                        email: _emailCtrl.text, password: _pwdCtrl.text);
                    if (!context.mounted) return;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyApp()));
                  } catch (e) {
                    print(e);
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
                          'Login',
                          style: TextStyle(color: w, fontSize: 14),
                        ),
                      ),
                    ))),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Not a member? ',
                style: TextStyle(fontSize: 14),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignUpAuthPage()));
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: blue,
                      fontSize: 14),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                    height: 1,
                    color: b.withOpacity(0.2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Or Login With',
                    style: TextStyle(fontSize: 13, color: b.withOpacity(0.28)),
                  ),
                ),
                Expanded(
                  child: Divider(
                    height: 0.1,
                    color: b.withOpacity(0.2),
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 0.1),
                    borderRadius: BorderRadius.circular(5)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 18),
                  child: Image(
                    image: AssetImage('lib/images/gicon.png'),
                    width: 22,
                    height: 22,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 0.1),
                    borderRadius: BorderRadius.circular(5)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 18),
                  child: Image(
                    image: AssetImage('lib/images/aicon.png'),
                    width: 22,
                    height: 22,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        'By continuing you acknowledge that you have read and understood and agree to our',
                    style:
                        TextStyle(fontSize: 10.0, color: b.withOpacity(0.28)),
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
                    style:
                        TextStyle(fontSize: 10.0, color: b.withOpacity(0.28)),
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
          ),
        ]),
      ),
    );
  }
}
