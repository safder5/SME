import 'package:ashwani/Models/iq_list.dart';
import 'package:ashwani/Models/item_tracking_model.dart';
import 'package:ashwani/Models/waste_bucket_model.dart';
import 'package:ashwani/Services/helper.dart';
import 'package:ashwani/constants.dart';
import 'package:ashwani/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:textfield_search/textfield_search.dart';

class SalesOrderReturnTransactions extends StatefulWidget {
  const SalesOrderReturnTransactions(
      {super.key, required this.itemsDelivered, required this.orderId});
  final List<Item>? itemsDelivered;
  final int orderId;

  @override
  State<SalesOrderReturnTransactions> createState() =>
      _SalesOrderReturnTransactionsState();
}

class _SalesOrderReturnTransactionsState
    extends State<SalesOrderReturnTransactions> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _itemnameController = TextEditingController();
  final TextEditingController _referencenoCtrl = TextEditingController();

  final auth = FirebaseAuth.instance.currentUser;

  Item selectedItem =
      Item(itemName: 'itemName', itemQuantity: 0, quantitySalesReturned: 0);

  ReturnItemTracking rit = ReturnItemTracking(
    orderId: 0,
    itemname: 'itemname',
  );

  int quantityReturned = 0;
  int? itemQuantity = 0;
  int? quantitysr = 0;
  String itemName = '';
  String itemUrl = '';
  String itemLimit = '';
  final now = DateTime.now();
  bool _isLoading = false;
  ItemTracking track = ItemTracking(itemName: 'itemName');
  bool prevData = false;
  bool _toInventory = true;

  Future<void> _executeFutures(ItemTracking track) async {
    await uploadTrack(track);
    await uploadItemInventorytracks();
    await checkPrevItemDeliveredData();
    await addItemtoSalesReturned();
    await createSalesReturn();
    _toInventory ? await updateInventory() : await addToWasteBucket();
    await updateItemDelivered(); //keep at last
  }

  void _handleSubmit() async {
    if (mounted) {
      setState(() {
        _isLoading = true; // Show loading overlay
      });
    }
    //  await  Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      await _executeFutures(track).then((_) {
        setState(() {
          _isLoading = false; // Hide loading overlay
        });
      });
    }
    if (!context.mounted) return;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MyApp()));
  }

  Future<void> updateItemDelivered() async {
    quantitysr = quantitysr! + quantityReturned;
    await FirebaseFirestore.instance
        .collection('UserData')
        .doc(auth!.email)
        .collection('orders')
        .doc('sales')
        .collection('sales_orders')
        .doc(widget.orderId.toString())
        .collection('itemsDelivered')
        .doc(_itemnameController.text)
        .update({'quantitySalesReturned': quantitysr});
  }

  Future<void> updateInventory() async {
    if (rit.toInventory == true) {
      try {
        DocumentReference docRef = FirebaseFirestore.instance
            .collection('UserData')
            .doc(auth!.email)
            .collection('Items')
            .doc(_itemnameController.text);
        DocumentSnapshot snapshot = await docRef.get();
        if (snapshot.exists && snapshot.data() != null) {
          itemQuantity = snapshot.get('itemQuantity');
          quantitysr = snapshot.get('quantitySalesReturned');

          await FirebaseFirestore.instance
              .collection('UserData')
              .doc(auth!.email)
              .collection('Items')
              .doc(_itemnameController.text)
              .update({
            'itemQuantity': (itemQuantity! + quantityReturned),
            'quantitySalesReturned': (quantitysr! + quantityReturned),
          });
        }
        print('3');
      } catch (e) {
        print('error uploading to inventory $e');
      }
    }
  }

  Future<void> addToWasteBucket() async {
    if (rit.toInventory == false) {
      WasteBucketItem waste = WasteBucketItem(
          itemname: _itemnameController.text,
          quantityWasted: quantityReturned,
          date: rit.date,
          orderId: widget.orderId,
          referenceNo: _referencenoCtrl.text,
          type: 'Sales Return');
      try {
        await FirebaseFirestore.instance
            .collection('UserData')
            .doc(auth!.email)
            .collection('waste')
            .doc(now.millisecondsSinceEpoch.toString())
            .set({
          'referenceNo': waste.referenceNo,
          'orderId': waste.orderId,
          'itemname': waste.itemname,
          'quantityWasted': waste.quantityWasted,
          'date': waste.date,
          'type': waste.type
        });
      } catch (e) {
        print(e);
      }
    }
  }

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
      'quantityReturned': track.quantityReturned,
    });
    print('1');
  }

  Future<void> createSalesReturn() async {
    try {
      await FirebaseFirestore.instance
          .collection('UserData')
          .doc(auth!.email)
          .collection('sales_returns')
          .doc(now.millisecondsSinceEpoch.toString())
          .set({
        'referenceNo': rit.referenceNo,
        'orderId': rit.orderId,
        'itemname': rit.itemname,
        'quantitySalesReturned': rit.quantitySalesReturned,
        'date': rit.date,
        'toInventory': rit.toInventory,
      });
    } catch (e) {
      print(e);
    }
    print('2');
  }

  Future<void> addItemtoSalesReturned() async {
    final String orderId = widget.orderId.toString();
    final String item =
        _itemnameController.text; // Trim to remove leading/trailing spaces

    try {
      if (prevData == false) {
        final DocumentReference docRef = FirebaseFirestore.instance
            .collection('UserData')
            .doc(auth!.email)
            .collection('orders')
            .doc('sales')
            .collection('sales_orders')
            .doc(orderId)
            .collection('returns')
            .doc(item);
        await docRef.set({
          'itemName': item,
          'quantitySalesReturned': rit.quantitySalesReturned,
        });
        print('0');
      }
    } catch (e) {
      print('yeh kya $e');
    }
  }

  checkPrevItemDeliveredData() async {
    try {
      final String orderId = widget.orderId.toString();
      final String item =
          _itemnameController.text; // Trim to remove leading/trailing spaces

      if (orderId.isNotEmpty && item.isNotEmpty) {
        final CollectionReference cRef = FirebaseFirestore.instance
            .collection('UserData')
            .doc(auth!.email)
            .collection('orders')
            .doc('sales')
            .collection('sales_orders')
            .doc(orderId)
            .collection('returns');

        DocumentSnapshot docSnap = await cRef.doc(item).get();
        if (docSnap.exists) {
          setState(() => prevData = true);
          int previousReturnQuantity = docSnap.get('quantitySalesReturned');
          await cRef.doc(item).update({
            'quantitySalesReturned':
                (previousReturnQuantity + rit.quantitySalesReturned!),
          });
        }
      }
    } catch (e) {
      print("error checking data :$e");
    }
  }

  Future<void> uploadItemInventorytracks() async {
    try {
      ItemTrackingModel itemTracking = ItemTrackingModel(
          orderID: widget.orderId.toString(),
          quantity: quantityReturned,
          reason: 'Sales Return');

      await FirebaseFirestore.instance
          .collection('UserData')
          .doc(auth!.email)
          .collection('Items')
          .doc(_itemnameController.text)
          .collection('tracks')
          .doc(widget.orderId.toString())
          .set({
        "orderID": itemTracking.orderID,
        'quantity': itemTracking.quantity,
        'reason': itemTracking.reason,
      });
    } catch (e) {
      print('error uploading item inventory tracks');
    }
  }

  getData() async {
    String itemname = _itemnameController.text;
    if (itemname.isNotEmpty && widget.itemsDelivered != null) {
      try {
        for (var i in widget.itemsDelivered!) {
          if (i.itemName == itemname) {
            setState(() {
              selectedItem = i;
              itemLimit = i.quantitySalesDelivered.toString();
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
    return widget.itemsDelivered!.map((item) => item.itemName).toList();
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
    return Stack(
      children: [
        Positioned(
          bottom: 0, // Adjust the position as needed
          left: 0, // Adjust the position as needed
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
                color: w,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
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
                      decoration: getInputDecoration(
                          hint: 'Search Item', errorColor: r),
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
                      decoration: getInputDecoration(
                          hint: '1.00', errorColor: Colors.red),
                      onChanged: (value) {
                        quantityReturned = int.parse(value);
                        rit.quantitySalesReturned = int.parse(value);
                        // String limit = await checkQuantityLimit();
                        // print(limit);
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      // validator: validateSOIQ,
                      controller: _referencenoCtrl,
                      cursorColor: blue,
                      cursorWidth: 1,
                      textInputAction: TextInputAction.next,
                      decoration: getInputDecoration(
                          hint: 'Reference number/ Bill number',
                          errorColor: Colors.red),
                      onChanged: (value) {
                        rit.referenceNo = value;
                        // String limit = await checkQuantityLimit();
                        // print(limit);
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Add this item back to Inventory',
                          style: TextStyle(fontWeight: FontWeight.w300),
                          textScaleFactor: 1,
                        ),
                        const Spacer(),
                        Switch(
                          value: _toInventory,
                          onChanged: (value) {
                            // When the user toggles the switch, update the state
                            setState(() {
                              _toInventory = !_toInventory;
                            });
                          },
                          activeColor: blue, // Color when switch is ON
                          activeTrackColor: Colors
                              .lightBlueAccent, // Track color when switch is ON
                          inactiveThumbColor: b, // Color when switch is OFF
                          inactiveTrackColor:
                              b25, // Track color when switch is OFF
                        ),
                      ],
                    ),
                    const Spacer(),
                    // const SizedBox(height: 24,),
                    GestureDetector(
                      onTap: () async {
                        try {
                          if (validateForm() == true) {
                            track = ItemTracking(
                                itemName: _itemnameController.text,
                                date: DateFormat('dd-MM-yyyy').format(now),
                                quantityReturned: quantityReturned);

                            rit = ReturnItemTracking(
                                orderId: widget.orderId,
                                itemname: _itemnameController.text,
                                referenceNo: _referencenoCtrl.text,
                                toInventory: _toInventory,
                                date: DateFormat('dd-MM-yyyy').format(now),
                                quantitySalesReturned: quantityReturned);

                            _isLoading ? null : _handleSubmit();

                            // if (!context.mounted) return;
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
          ),
        ),
        if (_isLoading) LoadingOverlay()
      ],
    );
  }
}
