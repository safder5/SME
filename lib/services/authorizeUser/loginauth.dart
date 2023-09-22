import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginAuthPage extends StatefulWidget {
  const LoginAuthPage({super.key});

  @override
  State<LoginAuthPage> createState() => _LoginAuthPageState();
}

class _LoginAuthPageState extends State<LoginAuthPage> {
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
                  final newUser = await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  if (newUser != null) {
                    Navigator.pushNamed(context, '/landingBypass');
                  }
                } catch (e) {
                  print(e);
                }
              },
              child: Text('Sign Up'))
        ]),
      ),
    );
  }
}
