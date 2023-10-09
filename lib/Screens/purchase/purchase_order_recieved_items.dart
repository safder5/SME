import 'package:ashwani/Models/iq_list.dart';
import 'package:ashwani/Services/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:textfield_search/textfield_search.dart';

import '../../constants.dart';

class PurchaseOrderRecievedItems extends StatefulWidget {
  const PurchaseOrderRecievedItems(
      {super.key, this.itemsofOrder, required this.orderId});
  final List<Item>? itemsofOrder;
  final int orderId;

  @override
  State<PurchaseOrderRecievedItems> createState() =>
      _PurchaseOrderRecievedItemsState();
}

class _PurchaseOrderRecievedItemsState
    extends State<PurchaseOrderRecievedItems> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _itemnameController = TextEditingController();
  final TextEditingController _refCtrl = TextEditingController();
  final auth = FirebaseAuth.instance.currentUser;

  bool _isLoading = false;
  String itemLimit = '';
  String refNumber = '';
  int quantityRecieved = 0;
  final now = DateTime.now();

  Item selectedItem = Item(itemName: ' ', itemQuantity: 0, quantityPurchase: 0);

  List<String?> getItemNames() {
    return widget.itemsofOrder!.map((item) => item.itemName).toList();
  }

  getData() async {
    String itemName = _itemnameController.text;
    if (itemName.isNotEmpty && widget.itemsofOrder != null) {
      try {
        for (var i in widget.itemsofOrder!) {
          if (i.itemName == itemName) {
            setState(() {
              selectedItem = i;
              itemLimit = i.quantityPurchase.toString();
            });
            break;
          }
        }
      } catch (e) {
        print(e);
      }
    }
  }

  String? validatePOIQ(String? value) {
    if (selectedItem.itemName!.isEmpty) {
      return null;
    }
    if (value == null || value.isEmpty) {
      return ' Please enter some Quantity';
    }
    int v = int.parse(value);
    if (v > int.parse(itemLimit)) {
      return 'Recieved Quantity cannot exceed Purchased Quantity ($itemLimit)';
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
                        validator: validatePOIQ,
                        cursorColor: blue,
                        cursorWidth: 1,
                        textInputAction: TextInputAction.next,
                        decoration: getInputDecoration(
                            hint: '1.00', errorColor: Colors.red),
                        onChanged: (value) {
                          quantityRecieved = int.parse(value);
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
                        onChanged: (value) {
                          refNumber = value;
                        },
                      ),
                      const Spacer(),
                      // const SizedBox(height: 24,),
                      GestureDetector(
                        onTap: () async {
                          try {
                            if (validateForm() == true) {
                              // track = ItemTracking(
                              //     itemName: _itemnameController.text,
                              //     date: DateFormat('dd-MM-yyyy').format(now),
                              //     quantityShipped: quantityRecieved);

                              // _isLoading ? null : _handleSubmit();

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
            )),
        if (_isLoading) LoadingOverlay()
      ],
    );
  }
}
