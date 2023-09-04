import 'package:ashwani/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

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
                    icon: Icon(Icons.arrow_back_ios))
              ],
            ),
            TextButton(
                onPressed: () {
                  try {
                    FirebaseAuth.instance.signOut();
                  } catch (e) {
                    print('error');
                  }
                  Navigator.of(context, rootNavigator: true)
                      .push(MaterialPageRoute(builder: (context) => MyApp()));
                },
                child: Text('Logout')),
          ],
        ),
      )),
    );
  }
}
