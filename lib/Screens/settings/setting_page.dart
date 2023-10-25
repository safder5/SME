import 'package:ashwani/Services/authorizeUser/loginauth.dart';
import 'package:ashwani/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 18,
                      color: b.withOpacity(0.5),
                    ))
              ],
            ),
            Column(
              children: [],
            ),
            const Spacer(),
            GestureDetector(
                onTap: () {
                  try {
                    FirebaseAuth.instance.signOut();
                  } catch (e) {
                    print('error');
                  }
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LoginAuthPage()));
                      Navigator.of(context).pushNamedAndRemoveUntil('/loginPage', (route) => false);
                },
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(width: 0.5, color: b)),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text('Logout'),
                    ))),
          ],
        ),
      )),
    );
  }
}
