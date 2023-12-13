import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class RateApp extends StatelessWidget {
  const RateApp({super.key});

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
                'Rate App',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ],
          )
        ]),
      ),
    );
  }
}