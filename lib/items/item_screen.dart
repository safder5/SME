import 'package:ashwani/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key, required this.itemname, required this.sIh});
  final String itemname;
  final String sIh;
  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // not in scroll view dumbass
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3,
            color: blue,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              LineIcons.angleLeft,
                              color: w,
                            )),
                        const SizedBox(width: 10),
                        Text(
                          'Item Details',
                          style: TextStyle(color: w),
                          textScaleFactor: 1.2,
                        ),
                        const Spacer(),
                        Icon(
                          FontAwesomeIcons.ellipsisVertical,
                          color: w,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.itemname,
                                style: TextStyle(
                                    color: w, fontWeight: FontWeight.w600),
                                textScaleFactor: 1.6,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'SIH: ${widget.sIh}',
                                style: TextStyle(
                                    color: w, fontWeight: FontWeight.w300),
                                textScaleFactor: 1,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            decoration: BoxDecoration(
                                color: w,
                                borderRadius: BorderRadius.circular(10)),
                            height: 100,
                            width: 100,
                            child: const Image(
                                image: AssetImage('lib/images/logoashapp.png')),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
