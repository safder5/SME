import 'package:ashwani/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';

import '../../Models/iq_list.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key, required this.item});
  final Item item;

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  String text = '';
  Color c = Colors.white;
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
                                widget.item.itemName!,
                                style: TextStyle(
                                    color: w, fontWeight: FontWeight.w600),
                                textScaleFactor: 1.6,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'SIH: ${widget.item.itemQuantity}',
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
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: b.withOpacity(0.03)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Item History',
                  textScaleFactor: 1,
                  style: TextStyle(fontWeight: FontWeight.w300, color: b),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                // physics: controllScroll,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: widget.item.itemTracks!.length,
                itemBuilder: (context, index) {
                  final itemTrack = widget.item.itemTracks![index];
                  if (itemTrack.reason == 'so') {
                    text = 'Sales Order';
                    c = gn;
                  } else if (itemTrack.reason == 'po') {
                    text = 'Purchase Order';
                    c = blue;
                  } else if (itemTrack.reason == 'u') {
                    text = 'By User';
                    c = b;
                  } else if (itemTrack.reason == 'Sales Return') {
                    text = 'Sales Return';
                    c = Color(colorPrimary);
                  } else {
                    text = 'Waste';
                    c = r;
                  }
          
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                          color: f7, borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  itemTrack.orderID.toString(),
                                  textScaleFactor: 0.9,
                                ),
                                Text(
                                  text,
                                  textScaleFactor: 0.8,
                                ),
                              ],
                            ),
                            Spacer(),
                            Text(
                              itemTrack.quantity.toString(),
                              textScaleFactor: 1.2,
                              style: TextStyle(
                                  color: c, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
