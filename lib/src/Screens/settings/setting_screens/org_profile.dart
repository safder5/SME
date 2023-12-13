import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class OrganisationProfile extends StatefulWidget {
  const OrganisationProfile({super.key});

  @override
  State<OrganisationProfile> createState() => _OrganisationProfileState();
}

class _OrganisationProfileState extends State<OrganisationProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(LineIcons.angleLeft)),
              const Text(
                'Organisation Profile',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              
            ],
          )
        ]),
      ),
    );
  }
}
