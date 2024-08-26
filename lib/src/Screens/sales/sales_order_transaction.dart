import 'package:ashwani/src/Models/iq_list.dart';
import 'package:ashwani/src/Models/item_tracking_model.dart';
import 'package:ashwani/src/Providers/iq_list_provider.dart';
import 'package:ashwani/src/Providers/new_sales_order_provider.dart';
import 'package:ashwani/src/Screens/sales/sales_order_page.dart';
import 'package:ashwani/src/Services/helper.dart';
import 'package:ashwani/src/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:textfield_search/textfield_search.dart';

class SalesOrderTransactionsShipped extends StatefulWidget {
  const SalesOrderTransactionsShipped(
      {super.key, this.items, required this.orderId, required this.customer});
  final List<Item>? items;
  final int orderId;
  final String customer;

  @override
  State<SalesOrderTransactionsShipped> createState() =>
      _SalesOrderTransactionsShippedState();
}

class _SalesOrderTransactionsShippedState
    extends State<SalesOrderTransactionsShipped> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _itemnameController = TextEditingController();
  final TextEditingController _quantityCtrl = TextEditingController();
  final auth = FirebaseAuth.instance.currentUser;

  Item selectedItem =
      Item(itemName: 'itemName', itemQuantity: 0, quantitySales: 0);
  int quantitySalesPreviouslyDelivered = 0;
  int quantityShipped = 0;
  int? itemQuantity = 0;
  String itemName = '';
  String itemUrl = '';
  String itemLimit = '';
  final now = DateTime.now();
  bool _isLoading = false;
  ItemTrackingSalesOrder track = ItemTrackingSalesOrder(itemName: 'itemName');
  bool prevData = false;

  Future<void> _executeFutures(ItemTrackingSalesOrder track) async {
    await checkPrevItemDeliveredData(); // its already available in the
    // sales order data so REMOVE IT

    await addItemtoSalesDelivered();
    // add track in sales order
    await uploadTrack(track);
    // update items list sales quantity in sales order
    await uploadtoSalesOrder();
    // make updates in inventory items
    await uploadToInventory();
    // update in inventory items
    await uploadItemInventorytracks();
    // upload ttracks in inventory items
    await addActivity();
    // update sales activity
    await updateStatus();
    // to update status of sales order
    updateAllProviders();
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
    {
      try {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SalesOrderPage(
                      orderId: widget.orderId,
                    )));
      } catch (e) {
        print('error loading to new purchase order page $e');
      }
    }
  }

  void updateAllProviders() {
    // ItemTrackingSalesOrder activity = ItemTrackingSalesOrder(
    //     itemName: track.itemName,
    //     quantityShipped: track.quantityShipped,
    //     date: track.date,
    //     customer: track.customer);
    try {
      Provider.of<NSOrderProvider>(context, listen: false)
          .updateSalesActivityinProvider(track);

      Provider.of<ItemsProvider>(context, listen: false)
          .updateItemsonSalesTransactioninProvider(
              _itemnameController.text, int.parse(_quantityCtrl.text));

      ItemTrackingModel itemTracking = ItemTrackingModel(
          orderID: widget.orderId.toString(),
          quantity: int.parse(_quantityCtrl.text),
          reason: 'Sales Delivered');
      Provider.of<ItemsProvider>(context, listen: false)
          .addItemtrackinProvider(itemTracking, _itemnameController.text);
      Provider.of<NSOrderProvider>(context, listen: false)
          .updateSalesItemsDeliveredProviders(
              widget.orderId,
              _itemnameController.text,
              int.parse(_quantityCtrl.text),
              Item(
                  itemName: _itemnameController.text,
                  quantitySalesDelivered: int.parse(_quantityCtrl.text)));
      Provider.of<NSOrderProvider>(context, listen: false)
          .updateStatustoProcessing(widget.orderId);
    } catch (e) {
      print("Error in updating all providers $e");
    }
  }

  Future<void> updateStatus() async {
    try {
      await FirebaseFirestore.instance
          .collection('UserData')
          .doc(auth!.email)
          .collection('orders')
          .doc('sales')
          .collection('sales_orders')
          .doc(widget.orderId.toString())
          .update({
        'status': "inprocess",
      });
    } catch (e) {
      print(e);
    }
  }

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
        'quantityShipped': track.quantityShipped,
        'customer': track.customer
      });
    } catch (e) {
      print('error while uploading sales activities $e');
    }
  }

  Future<void> uploadTrack(ItemTrackingSalesOrder track) async {
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
    print('1');
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
        'quantitySales': (selectedItem.quantitySales! - quantityShipped),
      });
    } catch (e) {
      print(e);
    }
    print('2');
  }

  Future<void> uploadItemInventorytracks() async {
    try {
      ItemTrackingModel itemTracking = ItemTrackingModel(
          orderID: widget.orderId.toString(),
          quantity: quantityShipped,
          reason: 'Sales Delivered');

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
        await FirebaseFirestore.instance
            .collection('UserData')
            .doc(auth!.email)
            .collection('Items')
            .doc(_itemnameController.text)
            .update({
          'itemQuantity': (itemQuantity! - int.parse(_quantityCtrl.text)),
          'quantitySales':
              (selectedItem.quantitySales! + int.parse(_quantityCtrl.text)),
        });
      }
    } catch (e) {
      print('error uploading to inventory $e');
    }
  }

  Future<void> addItemtoSalesDelivered() async {
    try {
      if (prevData == false) {
        DocumentReference docRref = FirebaseFirestore.instance
            .collection('UserData')
            .doc(auth!.email)
            .collection('orders')
            .doc('sales')
            .collection('sales_orders')
            .doc(widget.orderId.toString())
            .collection('itemsDelivered')
            .doc(_itemnameController.text);
        await docRref.set({
          'itemName': _itemnameController.text,
          'quantitySalesDelivered': quantityShipped,
        });
        print('0');
      }
    } catch (e) {
      print('yeh wala hai kya $e');
    }
  }

  Future<void> checkPrevItemDeliveredData() async {
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
            .collection('itemsDelivered');

        // final QuerySnapshot snapshot = await cRef.limit(1).get();
        DocumentSnapshot docSnap = await cRef.doc(item).get();
        if (docSnap.exists) {
          setState(() => prevData = true);
          int previousDeliveryQuantity = docSnap.get('quantitySalesDelivered');
          await cRef.doc(item).update({
            'quantitySalesDelivered':
                (previousDeliveryQuantity + quantityShipped),
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

  void checkPrevItemDeliveredDatainProvider() {
    try {
      final prov = Provider.of<NSOrderProvider>(context, listen: false);
      int orderIndex =
          prov.som.indexWhere((element) => element.orderID == widget.orderId);
      final order = prov.som[orderIndex];
      final itemsDel = order.itemsDelivered ?? <Item>[];
      if (itemsDel.isEmpty) {
        setState(() {
          prevData = false;
        });
      } else {
        int item = itemsDel.indexWhere(
            (element) => element.itemName == _itemnameController.text);
        final it = itemsDel[item];
        final q = it.quantitySalesDelivered ?? 0;
        setState(() {
          prevData = true;
          quantitySalesPreviouslyDelivered = q;
        });
      }
    } catch (e) {
      print('not selected item properly yet');
    }
  }

  void getData() async {
    String itemname = _itemnameController.text;
    if (itemname.isNotEmpty && widget.items != null) {
      try {
        for (var i in widget.items!) {
          if (i.itemName == itemname) {
            setState(() {
              selectedItem = i;
              itemLimit =
                  (i.originalQuantity! - quantitySalesPreviouslyDelivered)
                      .toString();
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
    if (selectedItem.itemName.isEmpty) {
      return null;
    }
    if (value == null || value.isEmpty) {
      return 'Please enter some quantity';
    }

    int v = int.parse(value);
    if (v > int.parse(itemLimit)) {
      return 'Quantity cannot exceed sales quantity (${int.parse(itemLimit)}).';
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
    // checkPrevItemDeliveredDatainProvider();
    _itemnameController.addListener(getData);
    _itemnameController.addListener(checkPrevItemDeliveredDatainProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        bottom: 0, // Adjust the position as needed
        left: 0, // Adjust the position as needed
        right: 0,
        child: Container(
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
                        getInputDecoration(hint: 'Search Item', errorColor: r),
                    initialList: getItemNames(),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    // validator: validateOrderNo,
                    controller: _quantityCtrl,
                    validator: validateSOIQ,
                    cursorColor: blue,
                    cursorWidth: 1,
                    textInputAction: TextInputAction.next,
                    decoration: getInputDecoration(
                        hint: '1.00', errorColor: Colors.red),
                    onChanged: (value) {
                      try {
                        quantityShipped = int.parse(value);
                      } catch (e) {
                        quantityShipped = int.parse('0');
                      } // String limit = await checkQuantityLimit();
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
                          track = ItemTrackingSalesOrder(
                              itemName: _itemnameController.text,
                              date: DateFormat('dd-MM-yyyy').format(now),
                              quantityShipped: quantityShipped,
                              customer: widget.customer);

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
                        style: TextStyle(color: w, fontSize: 14),
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
    ]);
  }
}
