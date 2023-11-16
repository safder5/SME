import 'package:ashwani/Providers/iq_list_provider.dart';
import 'package:ashwani/Services/helper.dart';
import 'package:ashwani/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../Models/iq_list.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key, required this.item});
  final Item item;

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  List<bool> isSelected = [true, false];
  List<String> toggleButtons = [
    ('Details'),
    ('Transactions'),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemsProvider>(builder: (_, prov, __) {
      final items = prov.allItems;
      final item = items
          .firstWhere((element) => element.itemName == widget.item.itemName);
      return Scaffold(
        backgroundColor: w,
        // not in scroll view dumbass
        body: Column(
          children: [
            Container(
              // height: MediaQuery.of(context).size.height / 3,
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
                                  item.itemName,
                                  style: TextStyle(
                                      color: w, fontWeight: FontWeight.w600),
                                  textScaleFactor: 1.6,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'SIH: ${item.itemQuantity}',
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
                                  image:
                                      AssetImage('lib/images/logoashapp.png')),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                              onPressed: () {
                                _showDialog(context, item.itemName);
                              },
                              child: Text(
                                'Stock Adjust',
                                style: TextStyle(color: w),
                              )),
                          const Spacer(),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              // height: MediaQuery.of(context).size.height * 0.66,
              color: w,
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      for (var i = 0; i < isSelected.length; i++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              for (var buttonIndex = 0;
                                  buttonIndex < isSelected.length;
                                  buttonIndex++) {
                                if (buttonIndex == i) {
                                  isSelected[buttonIndex] = true;
                                } else {
                                  isSelected[buttonIndex] = false;
                                }
                              }
                            });
                          },
                          child: Container(
                            // margin: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                            height: 45,
                            width: MediaQuery.of(context).size.width*0.45,
                            decoration: BoxDecoration(
                                color:
                                    isSelected[i] ? blue : b.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              toggleButtons[i],
                              style: TextStyle(
                                  color: isSelected[i] ? w : b,
                                  fontWeight: FontWeight.w300),
                              textScaleFactor: 1.2,
                            )),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected[0]) ItemDetails(item: item,),
            if (isSelected[1])
              ItemTransactionHistory(
                item: item,
              ),
           
          ],
        ),
      );
    });
  }
}

Future<void> _showDialog(BuildContext context, String itemName) async {
  final prov = Provider.of<ItemsProvider>(context, listen: false);
  final item =
      prov.allItems.firstWhere((element) => element.itemName == itemName);
  final sih = item.itemQuantity;
  showDialog(
      context: context,
      builder: ((context) {
        TextEditingController quantityController = TextEditingController();
        return AlertDialog(
          surfaceTintColor: w,
          backgroundColor: w,
          title: Text('Adjust In Hand Stock Quantity of $itemName by value?'),
          content: TextField(
            keyboardType: TextInputType.number,
            controller: quantityController,
            decoration: getInputDecoration(
                hint: 'Increase sIh quantity by ', errorColor: r),
          ),
          actions: [
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: blue),
                    )),
                const Spacer(),
                TextButton(
                    onPressed: () async {
                      final now = DateTime.now();
                      //save quantity and update
                      final int q =
                          int.parse(quantityController.text) + (sih ?? 0);
                      int tQ = int.parse(quantityController.text);
                      await prov.stockAdjustinFB(q, itemName, now, tQ);
                      prov.stockAdjustinProvider(q, itemName, now, tQ);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(color: blue),
                    )),
              ],
            )
          ],
        );
      }));
}

class ItemDetails extends StatelessWidget {
  const ItemDetails({super.key, required this.item});
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const  EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            height: 120,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: f7,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Item Stock Details',
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                const SizedBox(
                  height: 18,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.itemQuantity.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w300, color: blue),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text('Total stock',
                              style: TextStyle(fontWeight: FontWeight.w300),
                              textScaleFactor: 0.8)
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.quantitySales.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w300, color: blue),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            'Already Sold',
                            style: TextStyle(fontWeight: FontWeight.w300),
                            textScaleFactor: 0.8,
                          )
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (item.itemQuantity! -
                                    item.quantitySales!)
                                .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w300, color: blue),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            'Available for sale',
                            style: TextStyle(fontWeight: FontWeight.w300),
                            textScaleFactor: 0.8,
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
         
        ],
      ),
    );
  }
}

class ItemTransactionHistory extends StatelessWidget {
  const ItemTransactionHistory({super.key, required this.item});
  final Item item;

  @override
  Widget build(BuildContext context) {
    String text = '';
    Color c = Colors.white;
    return Expanded(
      child: ListView.builder(
          // reverse: true,
          // physics: controllScroll,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: item.itemTracks!.length,
          itemBuilder: (context, index) {
            final itemTrack = item.itemTracks![index];
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
              c = const Color(colorPrimary);
            } else if (itemTrack.reason == 'Stock Adjustment') {
              text = "Stock Adjustment";
              c = blue;
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
                      const Spacer(),
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
    );
  }
}
