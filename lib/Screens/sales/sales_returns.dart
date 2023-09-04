import 'package:ashwani/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

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
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 0.1),
            ),
            color: Colors.transparent,
          ),
          child: Column(children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
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
