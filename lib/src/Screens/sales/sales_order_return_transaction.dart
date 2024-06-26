import 'package:ashwani/src/Models/iq_list.dart';
import 'package:ashwani/src/Models/item_tracking_model.dart';
import 'package:ashwani/src/Providers/iq_list_provider.dart';
import 'package:ashwani/src/Providers/new_sales_order_provider.dart';
import 'package:ashwani/src/Providers/sales_returns_provider.dart';
import 'package:ashwani/src/Screens/sales/sales_order_page.dart';
import 'package:ashwani/src/Services/helper.dart';
import 'package:ashwani/src/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:textfield_search/textfield_search.dart';

class SalesOrderReturnTransactions extends StatefulWidget {
  const SalesOrderReturnTransactions(
      {super.key,
      required this.itemsDelivered,
      required this.orderId,
      required this.customer});
  final List<Item> itemsDelivered;
  final int orderId;
  final String customer;

  @override
  State<SalesOrderReturnTransactions> createState() =>
      _SalesOrderReturnTransactionsState();
}

class _SalesOrderReturnTransactionsState
    extends State<SalesOrderReturnTransactions> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _itemnameController = TextEditingController();
  final TextEditingController _referencenoCtrl = TextEditingController();
  final TextEditingController _quantityCtrl = TextEditingController();
  final auth = FirebaseAuth.instance.currentUser;

  Item selectedItem =
      Item(itemName: 'itemName', itemQuantity: 0, quantitySalesReturned: 0);

  SalesReturnItemTracking rit = SalesReturnItemTracking(
    orderId: 0,
    itemname: 'itemname',
  );

  int quantityReturned = 0;
  int? itemQuantity = 0;
  int? quantitysr = 0;
  String itemName = '';
  String itemUrl = '';
  int itemLimit = 0;
  final now = DateTime.now();
  bool _isLoading = false;
  ItemTrackingSalesOrder track = ItemTrackingSalesOrder(itemName: 'itemName');
  bool prevData = false;

  Future<void> _executeFutures(ItemTrackingSalesOrder track) async {
    await uploadTrack(track);
    await uploadItemInventorytracks(); //done
    await checkPrevItemReturnedData(); // we have this data already in sales order so no need to make this check REMOVE IT WITH REPLACEMENT
    await addItemtoSalesReturned(); // done
    await createSalesReturn();
    await updateInventory(); //: await addToWasteBucket();
    await updateItemDelivered(); //keep at last
    await addActivity(); //done
    updateAllProviders();
  }

  void updateAllProviders() {
    try {
      final prov = Provider.of<NSOrderProvider>(context, listen: false);
      final itemprov = Provider.of<ItemsProvider>(context, listen: false);

      itemprov.updateItemsonSalesReturninProvider(
          _itemnameController.text, int.parse(_quantityCtrl.text));

      ItemTrackingModel itemTracking = ItemTrackingModel(
          orderID: widget.orderId.toString(),
          quantity: quantityReturned,
          reason: 'Sales Return');

      itemprov.addItemtrackinProvider(itemTracking, _itemnameController.text);

      prov.updateSalesActivityinProvider(track);

      prov.updateSalesItemsReturnedProviders(
          widget.orderId,
          _itemnameController.text,
          int.parse(_quantityCtrl.text),
          Item(
              itemName: _itemnameController.text,
              quantitySalesReturned: int.parse(_quantityCtrl.text)));

      // prov.updateSalesOrderDetailsOnReturninProviders(_itemnameController.text,
      //     int.parse(_quantityCtrl.text), widget.orderId);

      Provider.of<SalesReturnsProvider>(context, listen: false)
          .addSalesReturninProvider(rit);
    } catch (e) {
      print('error $e');
    }
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
        // prevData ? updateInProvider() : createReturnForProvider();
        setState(() {
          _isLoading = false; // Hide loading overlay
        });
      });
    }
    if (!context.mounted) return;
    {
      try {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SalesOrderPage(orderId: widget.orderId)));
      } catch (e) {
        print('error loading to new purchase order page $e');
      }
    }
  }

  // void updateInProvider() {
  //   final sorProvider = Provider.of<NSOrderProvider>(context, listen: false);
  //   sorProvider.updateSalesItemsReturnedProviders(widget.orderId,
  //       _itemnameController.text, int.parse(_quantityCtrl.text));
  // }

  // void createReturnForProvider() {
  //   final sorProvider = Provider.of<NSOrderProvider>(context, listen: false);
  //   sorProvider.addSalesReturnInProvider(
  //       widget.orderId,
  //       _itemnameController.text,
  //       Item(
  //           itemName: _itemnameController.text,
  //           quantitySalesReturned: rit.quantitySalesReturned));
  // }

  Future<void> addActivity() async {
    try {
      FirebaseFirestore.instance
          .collection('UserData')
          .doc(auth!.email)
          .collection('sales_activities')
          .doc(now.millisecondsSinceEpoch.toString())
          .set({
        'itemName': track.itemName,
        'date': track.date,
        'quantityReturned': track.quantityReturned,
        'customer': track.customer
      });
    } catch (e) {
      print('error while uploading sales activities $e');
    }
  }

  Future<void> updateItemDelivered() async {
    try {
      await FirebaseFirestore.instance
          .collection('UserData')
          .doc(auth!.email)
          .collection('orders')
          .doc('sales')
          .collection('sales_orders')
          .doc(widget.orderId.toString())
          .collection('itemsDelivered')
          .doc(_itemnameController.text)
          .update({
        'quantitySalesReturned': (selectedItem.quantitySalesReturned! +
            int.parse(_quantityCtrl.text)),
        'quantitySalesDelivered': (selectedItem.quantitySalesDelivered! -
            int.parse(_quantityCtrl.text))
      });
      // we need original quantity here
      // final p = Provider.of<NPOrderProvider>(context, listen: false);
      // final orders = p.po;
      // final orderIndex =
      //     orders.indexWhere((element) => element.orderID == widget.orderId);
      // final order = orders[orderIndex];
      // final items = order.items ?? [];
      // final itemIndex = items.indexWhere(
      //     (element) => element.itemName == _itemnameController.text);
      // final orgQ = items[itemIndex].originalQuantity;
      // try {
      //   await FirebaseFirestore.instance
      //       .collection('UserData')
      //       .doc(auth!.email)
      //       .collection('orders')
      //       .doc('sales')
      //       .collection('sales_orders')
      //       .doc(widget.orderId.toString())
      //       .collection('items')
      //       .doc(_itemnameController.text)
      //       .update({
      //     'quantitySales':
      //         orgQ! - selectedItem.quantitySalesDelivered! + quantityReturned,
        // });
      // } catch (e) {
      //   print('yahan dekhle $e');
      // }
    } catch (e) {
      print('error while updating items delivered and details $e');
    }
  }

  Future<void> updateInventory() async {
    try {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('UserData')
          .doc(auth!.email)
          .collection('Items')
          .doc(_itemnameController.text);
      DocumentSnapshot snapshot = await docRef.get();
      if (snapshot.exists && snapshot.data() != null) {
        itemQuantity = snapshot.get('itemQuantity');
        int qsales = snapshot.get('quantitySales');
        // quantitysr = snapshot.get('quantitySalesReturned');

        await FirebaseFirestore.instance
            .collection('UserData')
            .doc(auth!.email)
            .collection('Items')
            .doc(_itemnameController.text)
            .update({
          'itemQuantity': (itemQuantity! + quantityReturned),
          'quantitySales': qsales + quantityReturned
          // 'quantitySalesReturned': (quantitysr! + quantityReturned),
        });
      }
      print('3');
    } catch (e) {
      print('error uploading to inventory $e');
    }
  }

  // Future<void> addToWasteBucket() async {
  //   if (rit.toInventory == false) {
  //     WasteBucketItem waste = WasteBucketItem(
  //         itemname: _itemnameController.text,
  //         quantityWasted: quantityReturned,
  //         date: rit.date,
  //         orderId: widget.orderId,
  //         referenceNo: _referencenoCtrl.text,
  //         type: 'Sales Return');
  //     try {
  //       await FirebaseFirestore.instance
  //           .collection('UserData')
  //           .doc(auth!.email)
  //           .collection('waste')
  //           .doc(now.millisecondsSinceEpoch.toString())
  //           .set({
  //         'referenceNo': waste.referenceNo,
  //         'orderId': waste.orderId,
  //         'itemname': waste.itemname,
  //         'quantityWasted': waste.quantityWasted,
  //         'date': waste.date,
  //         'type': waste.type
  //       });
  //     } catch (e) {
  //       print(e);
  //     }
  //   }
  // }

  Future<void> uploadTrack(ItemTrackingSalesOrder track) async {
    try {
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
    } catch (e) {
      print('error uploading Track $e');
    }
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

  checkPrevItemReturnedData() async {
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
      setState(() {
        prevData = false;
      });
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
          .doc(now.millisecondsSinceEpoch.toString())
          .set({
        "orderID": itemTracking.orderID,
        'quantity': itemTracking.quantity,
        'reason': itemTracking.reason,
      });
    } catch (e) {
      print('error uploading item inventory tracks');
    }
  }

  void getData() async {
    String itemname = _itemnameController.text;
    if (itemname.isNotEmpty && widget.itemsDelivered.isNotEmpty) {
      try {
        for (var i in widget.itemsDelivered) {
          if (i.itemName == itemname) {
            setState(() {
              selectedItem = i;
              if (i.quantitySalesReturned != null) {
                if (i.quantitySalesDelivered! > i.quantitySalesReturned!) {
                  itemLimit = (i.quantitySalesDelivered!);
                }
              } else {
                i.quantitySalesReturned = 0;
                itemLimit = (i.quantitySalesDelivered!);
              }
            });
            break;
          }
        }
      } catch (e) {
        print('mil gya $e');
      }
    }
  }

  List<String?> getItemNames() {
    return widget.itemsDelivered.map((item) => item.itemName).toList();
  }

  // String? validateSOIQ(String? value) {
  //   if (selectedItem.itemName.isEmpty) {
  //     return null;
  //   }
  //   if (value == null || value.isEmpty) {
  //     return 'Please enter some quantity';
  //   }

  //   int v = int.parse(value);
  //   if (v > int.parse(itemLimit)) {
  //     return 'Quantity cannot exceed inventory quantity (${int.parse(itemLimit)}).';
  //   }
  //   return null;
  // }

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
                      controller: _quantityCtrl,
                      // validator: validateSOIQ,
                      cursorColor: blue,
                      cursorWidth: 1,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: getInputDecoration(
                          hint: '1.00', errorColor: Colors.red),
                      onChanged: (value) {
                        try {
                          quantityReturned = int.parse(value);
                          rit.quantitySalesReturned = int.parse(value);
                        } catch (e) {
                          quantityReturned = int.parse('0');
                          rit.quantitySalesReturned = int.parse('0');
                        }

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
                    // Row(
                    //   children: [
                    //     const Text(
                    //       'Add this item back to Inventory',
                    //       style: TextStyle(fontWeight: FontWeight.w300),
                    //       textScaleFactor: 1,
                    //     ),
                    //     const Spacer(),
                    //     Switch(
                    //       value: _toInventory,
                    //       onChanged: (value) {
                    //         // When the user toggles the switch, update the state
                    //         setState(() {
                    //           _toInventory = !_toInventory;
                    //         });
                    //       },
                    //       activeColor: blue, // Color when switch is ON
                    //       activeTrackColor: Colors
                    //           .lightBlueAccent, // Track color when switch is ON
                    //       inactiveThumbColor: b, // Color when switch is OFF
                    //       inactiveTrackColor:
                    //           b25, // Track color when switch is OFF
                    //     ),
                    //   ],
                    // ),
                    const Spacer(),
                    // const SizedBox(height: 24,),
                    GestureDetector(
                      onTap: () async {
                        try {
                          String quantityText = _quantityCtrl.text;
                          final item = widget.itemsDelivered.firstWhere(
                              (element) =>
                                  element.itemName == _itemnameController.text);
                          final qsd = item.quantitySalesDelivered ?? 0;

                          if (selectedItem.itemName.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Select Item First')));
                          } else if (_quantityCtrl.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Enter some quantity to be returned')));
                          } else if (int.parse(_quantityCtrl.text) > qsd) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Quantity cannot exceed $qsd')));
                          } else if (quantityText.isNotEmpty &&
                              quantityText
                                  .trim()
                                  .replaceAll('-', '')
                                  .isNotEmpty) {
                            print('text is $quantityText');
                            // int quantityReturnedValue = int.parse(_quantityCtrl.text);

                            if (validateForm() == true) {
                              track = ItemTrackingSalesOrder(
                                  itemName: _itemnameController.text,
                                  date: DateFormat('dd-MM-yyyy').format(now),
                                  quantityReturned:
                                      int.parse(_quantityCtrl.text),
                                  customer: widget.customer);

                              rit = SalesReturnItemTracking(
                                  orderId: widget.orderId,
                                  itemname: _itemnameController.text,
                                  referenceNo: _referencenoCtrl.text,
                                  date: DateFormat('dd-MM-yyyy').format(now),
                                  quantitySalesReturned:
                                      int.parse(_quantityCtrl.text));

                              _isLoading ? null : _handleSubmit();
                            } else {
                              print('error validating form');
                            }
                            // if (!context.mounted) return;
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
                            color: w, fontSize: 14),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isLoading) const LoadingOverlay()
      ],
    );
  }
}
