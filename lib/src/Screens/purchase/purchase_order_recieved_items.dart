import 'package:ashwani/src/Screens/purchase/purchase_order_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:textfield_search/textfield_search.dart';

import '../../Models/iq_list.dart';
import '../../Models/item_tracking_model.dart';
import '../../Providers/iq_list_provider.dart';
import '../../Providers/new_purchase_order_provider.dart';
import '../../Services/helper.dart';
import '../../constants.dart';

class PurchaseOrderRecievedItems extends StatefulWidget {
  const PurchaseOrderRecievedItems(
      {super.key,
      this.itemsofOrder,
      required this.orderId,
      required this.vendor});
  final List<Item>? itemsofOrder;
  final int orderId;
  final String vendor;

  @override
  State<PurchaseOrderRecievedItems> createState() =>
      _PurchaseOrderRecievedItemsState();
}

class _PurchaseOrderRecievedItemsState
    extends State<PurchaseOrderRecievedItems> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _itemnameController = TextEditingController();
  final TextEditingController _quantityCtrl = TextEditingController();
  final TextEditingController _refCtrl = TextEditingController();
  final auth = FirebaseAuth.instance.currentUser;

  bool _isLoading = false;
  int itemLimit = 0;
  String refNumber = '';
  int quantityRecieved = 0;
  int quantityPreviouslyRecieved = 0;
  final now = DateTime.now();
  bool prevData = false;
  int? itemQuantity = 0;

  ItemTrackingPurchaseOrder track =
      ItemTrackingPurchaseOrder(itemName: 'itemName');
  Item selectedItem = Item(itemName: ' ', itemQuantity: 0, quantityPurchase: 0);

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
                builder: (context) => PurchaseOrderPage(
                      orderId: widget.orderId,
                    )));
      } catch (e) {
        print('error loading to new purchase order page $e');
      }
    }
  }

  Future<void> _executeFutures(ItemTrackingPurchaseOrder track) async {
    try {
      updateRespectiveProviders();

      await prevItemsRecievedData();
      // checks what quantity has been recieved earlier and marks #prevdata = true (if it has data). done

      await uploadItemsRecieved();
      // uploads item recieved creating a new items column in there if prevData = false .done

      // await updatePurchaseOrderItemDetails();
      // subtracts what values have been recieved and reduces the purchase quantity to be recieved

      await uploadPurchaseActivity(track);
      // uploads an activity track in purchase activity. done

      await uploadOrderTrack(track);
      // uploads a track inside the purchase order for future use if client wants. done

      await updateInventory();
      // updates and makes necessary changes in inventory items. done

      await updateItemTrack();
      // updates item track/activity in main inventory. done
    } catch (e) {
      print('Error executing futures $e');
    }
  }

  void updateRespectiveProviders() {
    try {
      final porProvider = Provider.of<NPOrderProvider>(context, listen: false);
      porProvider.purchaseRecievedProviderUpdate(widget.orderId,
          _itemnameController.text, int.parse(_quantityCtrl.text), track);
      print('D');

      porProvider.updatePurchaseActivityinProvider(track);
      print('D');

      Provider.of<ItemsProvider>(context, listen: false)
          .updateItemsonPurchaseTransactioninProvider(
              _itemnameController.text, int.parse(_quantityCtrl.text));
      print('D');
      ItemTrackingModel itemTracking = ItemTrackingModel(
          orderID: widget.orderId.toString(),
          quantity: quantityRecieved,
          reason: 'Purchase Recieved');
      Provider.of<ItemsProvider>(context, listen: false)
          .addItemtrackinProvider(itemTracking, _itemnameController.text);
      print('D');
    } catch (e) {
      print("Error in updating all providers $e");
    }
  }

  Future<void> prevItemsRecievedData() async {
    try {
      final String orderId = widget.orderId.toString();
      final String item = _itemnameController.text;

      if (orderId.isNotEmpty && item.isNotEmpty) {
        final CollectionReference cRef = FirebaseFirestore.instance
            .collection('UserData')
            .doc(auth!.email)
            .collection('orders')
            .doc('purchases')
            .collection('purchase_orders')
            .doc(orderId)
            .collection('itemsRecieved');

        DocumentSnapshot docSnap = await cRef.doc(item).get();
        if (docSnap.exists) {
          print('yes it exists');
          int previousRecievedQuantity = docSnap.get('quantityRecieved');
          await cRef.doc(item).update({
            'quantityRecieved': (previousRecievedQuantity + quantityRecieved)
          });

          setState(() => prevData = true);
        }
      }
    } catch (e) {
      print("error checking prevData $e");
    }
  }

  Future<void> uploadItemsRecieved() async {
    final String orderId = widget.orderId.toString();
    final String item = _itemnameController.text;
    try {
      if (prevData == false) {
        DocumentReference docRref = FirebaseFirestore.instance
            .collection('UserData')
            .doc(auth!.email)
            .collection('orders')
            .doc('purchases')
            .collection('purchase_orders')
            .doc(orderId)
            .collection('itemsRecieved')
            .doc(item);
        await docRref.set({
          'itemName': _itemnameController.text,
          'quantityRecieved': quantityRecieved,
        });
      }
    } catch (e) {
      print('error while uploading items recieved to firebastore $e');
    }
  }

  // Future<void> updatePurchaseOrderItemDetails() async {
  //   final String orderId = widget.orderId.toString();
  //   final String item = _itemnameController.text;
  //   try {
  //     CollectionReference cRref = FirebaseFirestore.instance
  //         .collection('UserData')
  //         .doc(auth!.email)
  //         .collection('orders')
  //         .doc('purchases')
  //         .collection('purchase_orders')
  //         .doc(orderId)
  //         .collection('items');
  //     DocumentSnapshot docSnap = await cRref.doc(item).get();
  //     int prevItemQuantity = docSnap.get('quantityPurchase');
  //     await cRref
  //         .doc(item)
  //         .update({'quantityPurchase': prevItemQuantity - quantityRecieved});
  //   } catch (e) {
  //     print('error while updating purchase order details');
  //   }
  // }

  Future<void> uploadPurchaseActivity(ItemTrackingPurchaseOrder track) async {
    try {
      FirebaseFirestore.instance
          .collection('UserData')
          .doc(auth!.email)
          .collection('purchase_activities')
          .doc(now.millisecondsSinceEpoch.toString())
          .set({
        'itemName': track.itemName,
        'date': track.date,
        'quantityRecieved': track.quantityRecieved,
        'vendor': track.vendor
      });
    } catch (e) {
      print('error while uploading purchase activities $e');
    }
  }

  Future<void> uploadOrderTrack(ItemTrackingPurchaseOrder track) async {
    try {
      FirebaseFirestore.instance
          .collection('UserData')
          .doc(auth!.email)
          .collection('orders')
          .doc('purchases')
          .collection('purchase_orders')
          .doc(widget.orderId.toString())
          .collection('tracks')
          .doc(now.millisecondsSinceEpoch.toString())
          .set({
        'itemName': track.itemName,
        'date': track.date,
        'quantityRecieved': track.quantityRecieved,
        'referenceNo': _refCtrl.text.toString(),
      });
    } catch (e) {
      print('error while uploading order track $e');
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
        await FirebaseFirestore.instance
            .collection('UserData')
            .doc(auth!.email)
            .collection('Items')
            .doc(_itemnameController.text)
            .update({
          'itemQuantity': (itemQuantity! + quantityRecieved),
          'quantityPurchase': (itemLimit - quantityRecieved),
        });
      }
    } catch (e) {
      print('error while updating inventory $e');
    }
  }

  Future<void> updateItemTrack() async {
    try {
      ItemTrackingModel itemTracking = ItemTrackingModel(
          orderID: widget.orderId.toString(),
          quantity: quantityRecieved,
          reason: 'Purchase Recieved');

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

  List<String?> getItemNames() {
    return widget.itemsofOrder!.map((item) => item.itemName).toList();
  }

  void checkPrevItemRecievedDatainProvider() {
    try {
      final prov = Provider.of<NPOrderProvider>(context, listen: false);
      int orderIndex =
          prov.po.indexWhere((element) => element.orderID == widget.orderId);
      final order = prov.po[orderIndex];
      final itemsDel = order.itemsRecieved ?? <ItemTrackingPurchaseOrder>[];
      if (itemsDel.isEmpty) {
        setState(() {
          prevData = false;
        });
      } else {
        int item = itemsDel.indexWhere(
            (element) => element.itemName == _itemnameController.text);
        final it = itemsDel[item];
        final q = it.quantityRecieved;
        setState(() {
          prevData = true;
          quantityPreviouslyRecieved = q;
        });
      }
    } catch (e) {
      print('not selected item properly yet');
    }
  }

  getData() async {
    String itemName = _itemnameController.text;
    if (itemName.isNotEmpty && widget.itemsofOrder != null) {
      try {
        for (var i in widget.itemsofOrder!) {
          if (i.itemName == itemName) {
            setState(() {
              selectedItem = i;
              itemLimit = i.originalQuantity! - quantityPreviouslyRecieved;
            });
            break;
          }
        }
      } catch (e) {
        print('get data error $e');
      }
    }
  }

  String? validatePOIQ(String? value) {
    if (selectedItem.itemName.isEmpty) {
      return null;
    }
    if (value == null || value.isEmpty) {
      return ' Please enter some Quantity';
    }
    int v = int.parse(value);
    if (v > itemLimit) {
      return 'Cannot exceed Purchased Quantity ($itemLimit)';
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
    super.initState();
    _itemnameController.addListener(getData);
    _itemnameController.addListener(checkPrevItemRecievedDatainProvider);
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
                  color: Theme.of(context).scaffoldBackgroundColor,
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
                        validator: validatePOIQ,
                        cursorColor: blue,
                        cursorWidth: 1,
                        textInputAction: TextInputAction.next,
                        decoration: getInputDecoration(
                            hint: '1.00', errorColor: Colors.red),
                        onChanged: (value) {
                          try {
                            quantityRecieved = int.parse(value);
                          } catch (e) {
                            quantityRecieved = int.parse('0');
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
                        controller: _refCtrl,
                        cursorColor: blue,
                        cursorWidth: 1,
                        textInputAction: TextInputAction.next,
                        decoration: getInputDecoration(
                            hint: 'Reference number/ Bill number',
                            errorColor: Colors.red),
                        // onChanged: (value) {
                        //   refNumber = int.parse(value.replaceAll(RegExp(r'[^0-9]'),''));
                        // },
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          try {
                            // validateForm();
                            if (validateForm() == true) {
                              print(true);
                              track = ItemTrackingPurchaseOrder(
                                  itemName: _itemnameController.text,
                                  date: DateFormat('dd-MM-yyyy').format(now),
                                  quantityRecieved: quantityRecieved,
                                  vendor: widget.vendor);

                              _isLoading ? null : _handleSubmit();

                              // if (!context.mounted) return;
                            } else {
                              print('error validating form');
                            }
                          } catch (e) {
                            //snackbar to show item not added
                            print('error $e');
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
            )),
        if (_isLoading) const LoadingOverlay()
      ],
    );
  }
}

// i need to validate the form then make changes -
//
