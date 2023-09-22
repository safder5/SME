import 'package:ashwani/Services/authorizeUser/loginauth.dart';
import 'package:ashwani/Services/authorizeUser/signupauth.dart';
import 'package:flutter/material.dart';

class AuthorizePage extends StatefulWidget {
  const AuthorizePage({super.key});

  @override
  State<AuthorizePage> createState() => _AuthorizePageState();
}

class _AuthorizePageState extends State<AuthorizePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                  children: [
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginAuthPage()));
                },
                child: Text('Login')),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpAuthPage()));
                },
                child: Text('Sign Up')),
                  ],
                ),
          )),
    );
  }
}
