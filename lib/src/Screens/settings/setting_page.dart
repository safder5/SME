import 'package:ashwani/src/Providers/providers_reset_manager.dart';
import 'package:ashwani/src/Screens/settings/setting_screens/customer_support.dart';
import 'package:ashwani/src/Screens/settings/setting_screens/rate_app.dart';
import 'package:ashwani/src/Screens/settings/setting_screens/about.dart';
import 'package:ashwani/src/Screens/settings/setting_screens/feedback.dart';
import 'package:ashwani/src/Screens/settings/setting_screens/org_profile.dart';
import 'package:ashwani/src/Screens/settings/setting_screens/privacy_security.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  // ContainerSettings(
                  //   title: 'Users',
                  //   widget: UserScreen(),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
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
                    await Future.delayed(const Duration(seconds: 1));
                    await FirebaseAuth.instance.signOut();
                    ProviderManager().resetAll();
                  } catch (e) {
                    print('error');
                  }
                  if (!context.mounted) return;
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const SignUpAuthPage()));
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/signupPage', (route) => false);
                },
                child: Container(
                  height: 71.0,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: w, borderRadius: BorderRadius.circular(10.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // CircleAvatar(
                        //   // maxRadius: 32,
                        //   radius: 16,
                        //   backgroundColor: b.withOpacity(0.06),
                        //   child: SvgPicture.asset(
                        //     'lib/icons/person.svg',
                        //     width: 14,
                        //     height: 14,
                        //   ),
                        // ),
                        //
                        const Spacer(),
                        Text(
                          'Sign Out',
                          style: TextStyle(
                              fontSize: 14, color: b.withOpacity(0.6)),
                        ),
                        const Spacer(),
                        // Center(
                        //   child: Icon(
                        //     LineIcons.angleRight,
                        //     color: b32,
                        //     size: 14,
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
              ),
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
