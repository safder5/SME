import 'package:ashwani/constants.dart';
import 'package:flutter/material.dart';

class SalesReturns extends StatefulWidget {
  const SalesReturns({super.key});

  @override
  State<SalesReturns> createState() => _SalesReturnsState();
}

class _SalesReturnsState extends State<SalesReturns> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: w,
      body: Center(
          child: GestureDetector(
        onTap: () {
          setState(() {
            selected = true;
          });
        },
        child: Container(
          height: 100,
          width: double.infinity,
          decoration: const BoxDecoration(
            
            color: Colors.transparent,
          ),
          child: Column(children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 30,
              height: 1,
              color: selected ? blue : t,
            )
          ]),
        ),
      )),
    );
  }
}
