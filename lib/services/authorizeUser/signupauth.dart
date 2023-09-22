import 'package:ashwani/Services/db_created.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          const Text('Sign Up '),
          TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'email',
            ),
            onChanged: (value) => email = value,
          ),
          TextField(
            obscureText: true,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.visiblePassword,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'password',
            ),
            onChanged: (value) => password = value,
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                  await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DBCreatingPage(email: email)));
                } catch (e) {
                  print(e);
                }
              },
              child: const Text('Sign Up'))
        ]),
      ),
    );
  }
}
