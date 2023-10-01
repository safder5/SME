import 'package:ashwani/Models/iq_list.dart';
import 'package:ashwani/Services/helper.dart';
import 'package:ashwani/constants.dart';
import 'package:ashwani/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:textfield_search/textfield_search.dart';

class SalesOrderTransactionsShipped extends StatefulWidget {
  const SalesOrderTransactionsShipped(
      {super.key, this.items, required this.orderId});
  final List<Item>? items;
  final int orderId;

  @override
  State<SalesOrderTransactionsShipped> createState() =>
      _SalesOrderTransactionsShippedState();
}

class _SalesOrderTransactionsShippedState
    extends State<SalesOrderTransactionsShipped> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _itemnameController = TextEditingController();
  final auth = FirebaseAuth.instance.currentUser;

  Item selectedItem =
      Item(itemName: 'itemName', itemQuantity: 0, quantitySales: 0);

  int quantityRecieved = 0;
  int? itemQuantity = 0;
  String itemName = '';
  String itemUrl = '';
  String itemLimit = '';
  final now = DateTime.now();

  Future<void> uploadTrack(ItemTracking track) async {
    await FirebaseFirestore.instance
        .collection('UserData')
        .doc(auth!.email)
        .collection('orders')
        .doc('sales')
        .collection('sales_orders')
        .doc(widget.orderId.toString())
        .collection('tracks')
        .doc(now.microsecondsSinceEpoch.toString())
        .set({
      'itemName': track.itemName,
      'date': track.date,
      'quantityShipped': track.quantityShipped,
    });
  }

  Future<void> uploadtoSalesOrder() async {
    try {
      await FirebaseFirestore.instance
          .collection('UserData')
          .doc(auth!.email)
          .collection('orders')
          .doc('sales')
          .collection('sales_orders')
          .doc(widget.orderId.toString())
          .collection('items')
          .doc(_itemnameController.text)
          .update({
        'quantitySales': (selectedItem.quantitySales! - quantityRecieved),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadToInventory() async {
    try {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('UserData')
          .doc(auth!.email)
          .collection('Items')
          .doc(_itemnameController.text);
      DocumentSnapshot snapshot = await docRef.get();
      if (snapshot.exists && snapshot.data() != null) {
        itemQuantity = snapshot.get('itemQuantity');
      }
      await FirebaseFirestore.instance
          .collection('UserData')
          .doc(auth!.email)
          .collection('Items')
          .doc(_itemnameController.text)
          .update({
        'itemQuantity': (itemQuantity! - quantityRecieved),
        'quantitySales': (selectedItem.quantitySales! - quantityRecieved),
      });
    } catch (e) {
      print('error uploading to inventory $e');
    }
  }

  getData() async {
    String itemname = _itemnameController.text;
    if (itemname.isNotEmpty && widget.items != null) {
      try {
        for (var i in widget.items!) {
          if (i.itemName == itemname) {
            setState(() {
              selectedItem = i;
              itemLimit = i.quantitySales.toString();
            });
            break;
          }
        }
      } catch (e) {
        print(e);
      }
    }
  }

  List<String?> getItemNames() {
    return widget.items!.map((item) => item.itemName).toList();
  }

  String? validateSOIQ(String? value) {
    if (selectedItem.itemName!.isEmpty) {
      return null;
    }
    if (value == null || value.isEmpty) {
      return 'Please enter some quantity';
    }

    int v = int.parse(value);
    if (v > int.parse(itemLimit)) {
      return 'Quantity cannot exceed inventory quantity (${int.parse(itemLimit)}).';
    }
    return null;
  }

  bool? validateForm() {
    final FormState form = _formKey.currentState!;
    if (form.validate()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _itemnameController.addListener(getData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
          color: w,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Select Items and Quantities Delivered'),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              CircleAvatar(
                backgroundColor: t,
                maxRadius: 22,
                child: const Image(
                  width: 44,
                  height: 44,
                  image: AssetImage('lib/images/itemimage.png'),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldSearch(
                minStringLength: 1,
                label: 'Search Item',
                controller: _itemnameController,
                decoration:
                    getInputDecoration(hint: 'Search Item', errorColor: r)
                        .copyWith(
                  suffix: GestureDetector(
                    onTap: () {
                      // add a unique item to items list
                      // Navigator.of(context, rootNavigator: true).push(
                      //     MaterialPageRoute(
                      //         builder: (context) => const AddItems()));
                    },
                    child: Icon(
                      LineIcons.plus,
                      size: 18,
                      color: blue,
                    ),
                  ),
                ),
                initialList: getItemNames(),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                // validator: validateOrderNo,
                validator: validateSOIQ,
                cursorColor: blue,
                cursorWidth: 1,
                textInputAction: TextInputAction.next,
                decoration:
                    getInputDecoration(hint: '1.00', errorColor: Colors.red)
                        .copyWith(
                  suffix: GestureDetector(
                    onTap: () {
                      // change type of unit
                      // Navigator.of(context,
                      //         rootNavigator: true)
                      //     .push(MaterialPageRoute(
                      //         builder: (context) =>
                      //             AddItems()));
                    },
                    child: Icon(
                      LineIcons.box,
                      size: 18,
                      color: blue,
                    ),
                  ),
                ),
                onChanged: (value) {
                  quantityRecieved = int.parse(value);
                  // String limit = await checkQuantityLimit();
                  // print(limit);
                },
              ),
              const SizedBox(
                height: 24,
              ),
              const Spacer(),
              // const SizedBox(height: 24,),
              GestureDetector(
                onTap: () async {
                  try {
                    if (validateForm() == true) {
                      final track = ItemTracking(
                          itemName: _itemnameController.text,
                          date: DateFormat('dd-MM-yyyy').format(now),
                          quantityShipped: quantityRecieved);

                      // add track in sales order
                      // await FirebaseFirestore.instance
                      //     .collection('UserData')
                      //     .doc(auth!.email)
                      //     .collection('orders')
                      //     .doc('sales')
                      //     .collection('sales_orders')
                      //     .doc(widget.orderId.toString())
                      //     .collection('tracks')
                      //     .doc(now.microsecondsSinceEpoch.toString())
                      //     .set({
                      //   'itemName': track.itemName,
                      //   'date': track.date,
                      //   'quantityShipped': track.quantityShipped,
                      // });
                      await uploadTrack(track);

                      // update items list sales quantity in sales order
                      // await FirebaseFirestore.instance
                      //     .collection('UserData')
                      //     .doc(auth!.email)
                      //     .collection('orders')
                      //     .doc('sales')
                      //     .collection('sales_orders')
                      //     .doc(widget.orderId.toString())
                      //     .collection('items')
                      //     .doc(_itemnameController.text)
                      //     .update({
                      //   'quantitySales':
                      //       (selectedItem.quantitySales! - quantityRecieved),
                      // });
                      await uploadtoSalesOrder();
                      // make updates in inventory items
                      // await FirebaseFirestore.instance
                      //     .collection('UserData')
                      //     .doc(auth!.email)
                      //     .collection('Items')
                      //     .doc(_itemnameController.text)
                      //     .update({
                      //   'itemQuantity':
                      //       (selectedItem.itemQuantity! + quantityRecieved),
                      //   'quantitySales':
                      //       (selectedItem.quantitySales! - quantityRecieved),
                      // });
                      await uploadToInventory();

                      // .where('itemName',
                      //     isEqualTo: _itemnameController.text).get();

                      // snap.docs.where((element) => false);

                      // update in inventory items
                      if (!context.mounted) return;
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyApp()));
                    } else {
                      print('error validating form');
                    }
                  } catch (e) {
                    //snackbar to show item not added
                    print('error on final addition $e');
                  }
                  // add items and pass the item and quantity to the list in sales order
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: blue,
                  ),
                  width: double.infinity,
                  height: 48,
                  child: Center(
                      child: Text(
                    'Add Item',
                    style: TextStyle(
                      color: w,
                    ),
                    textScaleFactor: 1.2,
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
