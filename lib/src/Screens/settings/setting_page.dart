import 'package:ashwani/src/Providers/providers_reset_manager.dart';
import 'package:ashwani/src/Screens/settings/customer_support.dart';
import 'package:ashwani/src/Screens/settings/rate_app.dart';
import 'package:ashwani/src/Screens/settings/setting_screens/about.dart';
import 'package:ashwani/src/Screens/settings/setting_screens/feedback.dart';
import 'package:ashwani/src/Screens/settings/setting_screens/org_profile.dart';
import 'package:ashwani/src/Screens/settings/setting_screens/privacy_security.dart';
import 'package:ashwani/src/Screens/settings/setting_screens/user.dart';
import 'package:ashwani/src/Services/authorizeUser/signupauth.dart';
import 'package:ashwani/src/constantWidgets/boxes.dart';
import 'package:ashwani/src/constants.dart';
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
      backgroundColor: w,
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  const Text(
                    'Settings',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        size: 26,
                        color: b.withOpacity(01),
                      )),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              const Column(
                children: [
                  ContainerSettings(
                    title: 'Organization Profile',
                    widget: OrganisationProfile(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ContainerSettings(
                    title: 'Users',
                    widget: UserScreen(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ContainerSettings(
                    title: 'Privacy & security',
                    widget: PrivacySecurity(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ContainerSettings(
                    title: 'About',
                    widget: AboutScreen(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ContainerSettings(
                    title: 'Feedback',
                    widget: FeedbackScreen(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ContainerSettings(
                    title: 'Rate App',
                    widget: RateApp(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ContainerSettings(
                    title: 'Costumer Support',
                    widget: CustomerSupport(),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                  onTap: () async {
                    try {
                      ProviderManager().resetAll();
                      await Future.delayed(const Duration(seconds: 1));
                      await FirebaseAuth.instance.signOut();
                      // if (FirebaseAuth.instance.currentUser == null) {
                      //   try {
                      //     // Provider.of<NSOrderProvider>(context, listen: false)
                      //     //     .clearAll();
                      //     // print('1');
                      //     // Provider.of<NPOrderProvider>(context, listen: false)
                      //     //     .clearAll(); print('1');
                      //     // Provider.of<InventorySummaryProvider>(context,
                      //     //         listen: false)
                      //     //     .clearAll();
                      //     print('1');
                      //     // Provider.of<PurchaseReturnsProvider>(context,
                      //     //         listen: false)
                      //     //     .clearPurchaseReturns(); print('1');
                      //     // Provider.of<SalesReturnsProvider>(context,
                      //     //         listen: false)
                      //     //     .clearSalesReturns(); print('1');
                      //   } catch (e) {
                      //     print('error clearing providers $e');
                      //   }
                      // }
                    } catch (e) {
                      print('error');
                    }
                    if (!context.mounted) return;
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const SignUpAuthPage()));
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/signupPage', (route) => false);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 53,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(width: 0.5, color: b)),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Center(child: Text('Logout')),
                      ))),
              const SizedBox(
                height: 32,
              )
            ],
          ),
        ),
      )),
    );
  }
}
