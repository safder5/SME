import 'package:flutter/material.dart';

class AllActivityHome extends StatefulWidget {
  const AllActivityHome({super.key});

  @override
  State<AllActivityHome> createState() => _AllActivityHomeState();
}

class _AllActivityHomeState extends State<AllActivityHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}