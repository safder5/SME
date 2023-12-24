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
import '../../Providers/purchase_returns_provider.dart';
import '../../Services/helper.dart';
import '../../constants.dart';

class PurchaseOrderReturnItems extends StatefulWidget {
  const PurchaseOrderReturnItems(
      {super.key,
      this.itemsRecieved,
      required this.orderId,
      required this.vendor});
  final List<ItemTrackingPurchaseOrder>? itemsRecieved;
  final int orderId;
  final String vendor;

  @override
  State<PurchaseOrderReturnItems> createState() =>
      _PurchaseOrderReturnItemsState();
}

class _PurchaseOrderReturnItemsState extends State<PurchaseOrderReturnItems> {
  bool isLoading = false;
  int quantityReturned = 0;
  int itemLimit = 0;
  bool toSeller = true;
  final now = DateTime.now();
  ItemTrackingPurchaseOrder selectedItem =
      ItemTrackingPurchaseOrder(itemName: '');
  PurchaseReturnItemTracking prit =
      PurchaseReturnItemTracking(orderId: 0, itemname: '');
  ItemTrackingPurchaseOrder track = ItemTrackingPurchaseOrder(itemName: '');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _itemnameController = TextEditingController();
  final TextEditingController _quantityCtrl = TextEditingController();
  final TextEditingController _refCtrl = TextEditingController();

  final auth = FirebaseAuth.instance.currentUser;

  Future<void> _handleSubmit() async {
    if (mounted) {
      setState(() {
        isLoading = true; // Show loading overlay
      });
    }
    //  await  Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      await _executeFutures(track).then((_) {
        setState(() {
          isLoading = false; // Hide loading overlay
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

    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => const MyApp()));
  }

  Future<void> _executeFutures(ItemTrackingPurchaseOrder track) async {
    try {
      await updateItemRecievedforReturns();
      // update the items recieved and returned values for the purchase order
      await createItemReturned();
      // checks if the return of that item is already available and then accordingly updates value or creates a new return in the returns list
      // returns list has to with the orders in DB
      await itemreturnedPurchaseOrder();

      await uploadOrderTrack();
      // it does something i dont completely get it
      await purchaseActivity();
      // create activity track for purchase activity
      await updateInventoryItems();
      // make changes in inventory items
      await trackInventoryItems();
      // create track for inventory item transacted with.
      updateRespectiveProviders();
    } catch (e) {
      print('error executing futures $e');
    }
  }

  void updateRespectiveProviders() {
    try {
      final porProvider = Provider.of<NPOrderProvider>(context, listen: false);
      porProvider.purchaseReturnProviderUpdate(widget.orderId,
          _itemnameController.text, int.parse(_quantityCtrl.text), track);

      // porProvider.updateDetailsafterReturninProvider(
      //     _itemnameController.text, quantityReturned, widget.orderId);

      porProvider.updatePurchaseActivityinProvider(track);

      Provider.of<PurchaseReturnsProvider>(context, listen: false)
          .addPurchaseReturninProvider(prit);

      Provider.of<ItemsProvider>(context, listen: false)
          .updateItemsonPurchaseReturninProvider(
              _itemnameController.text, int.parse(_quantityCtrl.text));

      ItemTrackingModel itemTracking = ItemTrackingModel(
          orderID: widget.orderId.toString(),
          quantity: quantityReturned,
          reason: 'Purchase Returned');
      Provider.of<ItemsProvider>(context, listen: false)
          .addItemtrackinProvider(itemTracking, _itemnameController.text);
    } catch (e) {
      print("Error updating provider $e");
    }
  }

  Future<void> updateItemRecievedforReturns() async {
    // final provider = Provider.of<NPOrderProvider>(context, listen: false);
    // var po =
    //     provider.po.firstWhere((element) => element.orderID == widget.orderId);
    // final items = po.items ?? [];
    // final qPd = items
    //     .firstWhere((element) => element.itemName == _itemnameController.text)
    //     .quantityPurchase;
    String id = widget.orderId.toString();
    if (selectedItem.quantityReturned == 0) {
      try {
        int qRt = int.parse(_quantityCtrl.text);
        int qRc = selectedItem.quantityRecieved - qRt;
        
        await FirebaseFirestore.instance
            .collection('UserData')
            .doc(auth!.email)
            .collection('orders')
            .doc('purchases')
            .collection('purchase_orders')
            .doc(id)
            .collection('itemsRecieved')
            .doc(_itemnameController.text)
            .update({
          'quantityRecieved': qRc,
          'quantityReturned': qRt,
        });
        // also updating details part in here
        // await FirebaseFirestore.instance
        //     .collection('UserData')
        //     .doc(auth!.email)
        //     .collection('orders')
        //     .doc('purchases')
        //     .collection('purchase_orders')
        //     .doc(id)
        //     .collection('items')
        //     .doc(_itemnameController.text)
        //     .update({
        //   'quantityPurchase': qPd ?? 0 + quantityReturned,
        // });
      } catch (e) {
        print(' error while updating with 0 quantity returned $e');
      }
    } else if (selectedItem.quantityReturned != 0) {
      try {
        int qRt = selectedItem.quantityReturned + quantityReturned;
        int qRc = selectedItem.quantityRecieved - quantityReturned;
        await FirebaseFirestore.instance
            .collection('UserData')
            .doc(auth!.email)
            .collection('orders')
            .doc('purchases')
            .collection('purchase_orders')
            .doc(id)
            .collection('itemsRecieved')
            .doc(_itemnameController.text)
            .update({
          'quantityRecieved': qRc,
          'quantityReturned': qRt,
        });
        //  await FirebaseFirestore.instance
        //     .collection('UserData')
        //     .doc(auth!.email)
        //     .collection('orders')
        //     .doc('purchases')
        //     .collection('purchase_orders')
        //     .doc(id)
        //     .collection('items')
        //     .doc(_itemnameController.text)
        //     .update({
        //   'quantityPurchase': qPd ?? 0 + quantityReturned,
        // });
      } catch (e) {
        print(' error uploading with quantity returned > 0 $e');
      }
    }
  }

  Future<void> createItemReturned() async {
    try {
      await FirebaseFirestore.instance
          .collection('UserData')
          .doc(auth!.email)
          .collection('purchase_returns')
          .doc(now.millisecondsSinceEpoch.toString())
          .set({
        'referenceNo': prit.referenceNo,
        'orderId': prit.orderId,
        'itemname': prit.itemname,
        'quantityPurchaseReturned': prit.quantity,
        'date': prit.date,
      });
    } catch (e) {
      print('error while creating itemreturned');
    }
  }

  Future<void> itemreturnedPurchaseOrder() async {
    try {
      if (selectedItem.quantityReturned == 0) {
        await FirebaseFirestore.instance
            .collection('UserData')
            .doc(auth!.email)
            .collection('orders')
            .doc('purchases')
            .collection('purchase_orders')
            .doc(widget.orderId.toString())
            .collection('returns')
            .doc(track.itemName)
            .set({
          'itemName': track.itemName,
          'quantityReturned': track.quantityReturned,
        });
      } else {
        // error hai yahan kyunki doc milliseconds wala change hojayega so take care of that
        await FirebaseFirestore.instance
            .collection('UserData')
            .doc(auth!.email)
            .collection('orders')
            .doc('purchases')
            .collection('purchase_orders')
            .doc(widget.orderId.toString())
            .collection('returns')
            .doc(track.itemName)
            .update({
          'itemName': track.itemName,
          'quantityReturned':
              (selectedItem.quantityReturned + track.quantityReturned),
        });
      }
    } catch (e) {
      print(
          'error wwhile creating itemReturns Purchase Order $e ${selectedItem.quantityReturned}');
    }
  }

  Future<void> uploadOrderTrack() async {
    try {
      await FirebaseFirestore.instance
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
        'quantityReturned': track.quantityReturned,
        'referenceNo': _refCtrl.text.toString()
      });
      print('1');
    } catch (e) {
      print('error uploading Track $e');
    }
  }

  Future<void> purchaseActivity() async {
    try {
      FirebaseFirestore.instance
          .collection('UserData')
          .doc(auth!.email)
          .collection('purchase_activities')
          .doc(now.millisecondsSinceEpoch.toString())
          .set({
        'itemName': track.itemName,
        'date': track.date,
        'quantityReturned': track.quantityReturned,
        'vendor': track.vendor
      });
    } catch (e) {
      print('error while uploading purchase activities $e');
    }
  }

  Future<void> updateInventoryItems() async {
    try {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('UserData')
          .doc(auth!.email)
          .collection('Items')
          .doc(_itemnameController.text);
      DocumentSnapshot snapshot = await docRef.get();
      if (snapshot.exists && snapshot.data() != null) {
        int itemQuantity = snapshot.get('itemQuantity');
        await FirebaseFirestore.instance
            .collection('UserData')
            .doc(auth!.email)
            .collection('Items')
            .doc(_itemnameController.text)
            .update({
          'itemQuantity': (itemQuantity - quantityReturned),
          // 'quantityPurchase': (itemLimit - quantityRecieved), // nothing should happen here or maybe it can i am not sure so check with CLIENT
        });
      }
    } catch (e) {
      print('error while updating inventory $e');
    }
  }

  Future<void> trackInventoryItems() async {
    try {
      ItemTrackingModel itemTracking = ItemTrackingModel(
          orderID: widget.orderId.toString(),
          quantity: quantityReturned,
          reason: 'Purchase Returned');

      await FirebaseFirestore.instance
          .collection('UserData')
          .doc(auth!.email)
          .collection('Items')
          .doc(_itemnameController.text)
          .collection('tracks')
          .doc(now.millisecondsSinceEpoch.toString())
          .set({
        'orderID': itemTracking.orderID,
        'quantity': itemTracking.quantity,
        'reason': itemTracking.reason,
      });
    } catch (e) {
      print('error uploading item inventory tracks');
    }
  }

  List<String?> getItemNames() {
    return widget.itemsRecieved!.map((item) => item.itemName).toList();
  }

  getData() async {
    String itemName = _itemnameController.text;
    if (itemName.isNotEmpty && widget.itemsRecieved != null) {
      try {
        for (var i in widget.itemsRecieved!) {
          if (i.itemName == itemName) {
            setState(() {
              selectedItem = i;
              itemLimit = i.quantityRecieved;
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
                          //check for value going null in all 4 bottom sheets
                          try {
                            quantityReturned = int.parse(value);
                          } catch (e) {
                            quantityReturned = int.parse('0');
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
                                  quantityReturned: quantityReturned,
                                  vendor: widget.vendor);

                              prit = PurchaseReturnItemTracking(
                                  orderId: widget.orderId,
                                  itemname: _itemnameController.text,
                                  referenceNo: _refCtrl.text,
                                  date: DateFormat('dd-MM-yyyy').format(now),
                                  quantity: quantityReturned);

                              isLoading ? null : _handleSubmit();

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
                              color: w, fontSize: 14
                            ),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
        if (isLoading) const LoadingOverlay()
      ],
    );
  }
}
